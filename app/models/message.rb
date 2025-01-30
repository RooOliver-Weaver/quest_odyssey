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
  end
end
