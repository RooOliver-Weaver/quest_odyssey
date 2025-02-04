class CampaignCharacter < ApplicationRecord
  belongs_to :campaign
  belongs_to :user
  belongs_to :character, optional: true
  has_many :messages

  validates :user_id, presence: true
end
