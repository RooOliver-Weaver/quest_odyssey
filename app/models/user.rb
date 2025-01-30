class User < ApplicationRecord

  has_many :characters
  has_many :campaigns
  has_many :campaign_characters
  has_many :player_campaigns, through: :campaign_characters, source: :campaign
  has_many :messages

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
