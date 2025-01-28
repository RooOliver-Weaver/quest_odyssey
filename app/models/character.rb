class Character < ApplicationRecord
  belongs_to :user

  validates :name, :race, :speciality, :level, presence: true
  validates :level, numericality: { only_integer: true, default: 0, less_than_or_equal_to: 20}
  validates :speciality, inclusion: { in: %w(barbarian wizard rogue bard cleric fighter sorcerer), message: "%{value} is not a valid speciality" }
end
