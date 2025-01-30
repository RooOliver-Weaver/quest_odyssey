class User < ApplicationRecord

  has_many :characters
  has_many :campaigns
  has_many :campaign_characters

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
