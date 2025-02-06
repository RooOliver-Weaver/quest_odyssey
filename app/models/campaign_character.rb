class CampaignCharacter < ApplicationRecord
  belongs_to :campaign
  belongs_to :user
  belongs_to :character, optional: true
  has_many :messages
  has_many :character_sessions, dependent: :destroy
  validates :user_id, presence: true

  after_create_commit :broadcast_message

  private

  def broadcast_message

    recipient = (self.user)
    notification_message = "#{campaign.user.nickname} invited you to #{campaign.name}!"
    campaign_url = Rails.application.routes.url_helpers.root_path

    notification = Notification.create!(
      user: recipient,
      message: notification_message,
      url: campaign_url,
      read: false
    )

    broadcast_append_to "notifications_#{recipient.id}",
      partial: "notifications/notification",
      target: "notifications",
      locals: { message: self, recipient: recipient, notification: notification },
      formats: [:turbo_stream]

    broadcast_update_to "notifications_#{recipient.id}",
      target: "notifications_badge",
      partial: "notifications/badge",
      locals: { user: recipient }

    broadcast_remove_to "notifications_#{recipient.id}",
      target: "no_notifications"

  end
end
