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

    recipients = campaign.users.to_a + [campaign.user]
    recipients.reject! { |recipient| recipient == user }

    recipients.each do |recipient|
      Notification.create!(
        user: recipient,
        message: "New message in #{campaign.name} from #{user.nickname}",
        url: Rails.application.routes.url_helpers.campaign_path(campaign),
        read: false
      )

      broadcast_append_to "notifications_#{recipient.id}",
                          partial: "notifications/notification",
                          target: "notifications",
                          locals: { message: self, recipient: recipient }
    end
  end
end
