class Campaign < ApplicationRecord
  belongs_to :user

  validates :name, :setting, :description, presence: true
end
