class Session < ApplicationRecord
  attribute :status, :string
  belongs_to :campaign
  has_many :characters, through: :campaign
  has_many :character_sessions, dependent: :destroy
  enum :status, { confirmed: 'confirmed', cancelled: 'cancelled', pending: 'pending' }

  def start_time
    date.to_date
  end
end
