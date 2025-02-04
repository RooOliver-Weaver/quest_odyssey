class Campaign < ApplicationRecord
  belongs_to :user
  has_many :campaign_characters, dependent: :destroy
  has_many :users, through: :campaign_characters
  has_many :messages, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :character_sessions, through: :sessions, dependent: :destroy

  validates :name, :setting, :description, presence: true
end
