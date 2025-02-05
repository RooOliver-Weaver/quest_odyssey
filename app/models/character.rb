class Character < ApplicationRecord
  has_one_attached :portrait, dependent: :purge_later
  store_attribute :stats, :strength, :integer, default: 10
  store_attribute :stats, :dexterity, :integer, default: 10
  store_attribute :stats, :constitution, :integer, default: 10
  store_attribute :stats, :intelligence, :integer, default: 10
  store_attribute :stats, :wisdom, :integer, default: 10
  store_attribute :stats, :charisma, :integer, default: 10

  belongs_to :user

  validates :name, :race, :speciality, :level, presence: true
  validates :level, numericality: { only_integer: true, default: 0, less_than_or_equal_to: 20}
  validates :speciality, inclusion: { in: %w(Barbarian Wizard Rogue Bard Cleric Fighter Sorcerer Druid Ranger Paladin Monk Warlock), message: "%{value} is not a valid speciality" }
  validates :portrait, content_type: { in: [:jpeg, :png, :webp, :tiff, :svg], spoofing_protection: true }, size: { less_than: 5.megabytes, message: "is too big" }

  after_create_commit :store_public_id_in_metadata
  after_destroy :purge_portrait

  private

  def store_public_id_in_metadata
    return unless portrait.attached?

    portrait_file = portrait.download

    response = Cloudinary::Uploader.upload(StringIO.new(portrait_file))

    portrait.blob.update(metadata: { public_id: response['public_id'] })
  end

  def purge_portrait
    if portrait.attached? && portrait.blob.metadata[:public_id]
      public_id = portrait.blob.metadata[:public_id]
      Cloudinary::Uploader.destroy(public_id)
    else
      Rails.logger.error "No public_id found for the portrait attachment."
    end
  rescue => e
    Rails.logger.error "Cloudinary deletion failed for campaign #{id}: #{e.message}"
  end

  def self.purge_all_portraits
    all.each do |character|
      character.portrait.purge if character.portrait.attached?
    end
  end
end
