class Campaign < ApplicationRecord
  belongs_to :user
  has_many :campaign_characters, dependent: :destroy

  validates :name, :setting, :description, presence: true
end
