class Message < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  after_create_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to "campaign_#{campaign.id}_messages",
                        partial: "campaigns/message",
                        target: "messages",
                        locals: { message: self }

    recipients = (campaign.users.to_a + [campaign.user]).uniq
    recipients.reject! { |recipient| recipient == user }

    notification_message = "New message in #{campaign.name}"
    campaign_url = Rails.application.routes.url_helpers.campaign_path(campaign)

    recipients.each do |recipient|
      existing_notification = Notification.find_by(
        user: recipient,
        message: notification_message,
        read: false
      )

      if existing_notification
        existing_notification.increment!(:occurrence_count)
      else
        existing_notification = Notification.create!(
          user: recipient,
          message: notification_message,
          url: campaign_url,
          read: false,
          occurrence_count: 1
        )
      end

      broadcast_append_to "notifications_#{recipient.id}",
                          partial: "notifications/notification",
                          target: "notifications",
                          locals: { message: self, recipient: recipient, notification: existing_notification },
                          formats: [:turbo_stream]

      broadcast_update_to "notifications_#{recipient.id}",
                          target: "notifications_badge",
                          partial: "notifications/badge",
                          locals: { user: recipient }

      broadcast_remove_to "notifications_#{recipient.id}",
                          target: "no_notifications"
    end
  end
end
