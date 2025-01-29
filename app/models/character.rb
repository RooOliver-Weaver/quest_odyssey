class Character < ApplicationRecord
  has_one_attached :portrait
  store_attribute :stats, :strength, :integer, default: 10
  store_attribute :stats, :dexterity, :integer, default: 10
  store_attribute :stats, :constitution, :integer, default: 10
  store_attribute :stats, :intelligence, :integer, default: 10
  store_attribute :stats, :wisdom, :integer, default: 10
  store_attribute :stats, :charisma, :integer, default: 10

  belongs_to :user

  validates :name, :race, :speciality, :level, presence: true
  validates :level, numericality: { only_integer: true, default: 0, less_than_or_equal_to: 20}
  validates :speciality, inclusion: { in: %w(Barbarian Wizard Rogue Bard Cleric Fighter Sorcerer Druid Ranger Paladin), message: "%{value} is not a valid speciality" }
end
