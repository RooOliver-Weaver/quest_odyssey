class Campaign < ApplicationRecord
  belongs_to :user
  has_many :campaign_characters, dependent: :destroy
  has_many :users, through: :campaign_characters
  has_many :messages, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :character_sessions, through: :sessions, dependent: :destroy
  has_one_attached :image, dependent: :purge_later
  include PgSearch::Model
  multisearchable against: [:name, :description, :setting]

  validates :name, :setting, :description, presence: true

  after_create_commit :store_public_id_in_metadata
  after_destroy :purge_image

  private

  def store_public_id_in_metadata
    return unless image.attached?

    image_file = image.download

    response = Cloudinary::Uploader.upload(StringIO.new(image_file))

    image.blob.update(metadata: { public_id: response['public_id'] })
  end

  def purge_image
    if image.attached? && image.blob.metadata[:public_id]
      public_id = image.blob.metadata[:public_id]
      Cloudinary::Uploader.destroy(public_id)
    else
      Rails.logger.error "No public_id found for the image attachment."
    end
  rescue => e
    Rails.logger.error "Cloudinary deletion failed for campaign #{id}: #{e.message}"
  end

  def self.purge_all_images
    all.each do |campaign|
      campaign.image.purge if campaign.image.attached?
    end
  end
end
