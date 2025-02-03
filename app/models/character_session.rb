class CharacterSession < ApplicationRecord
  belongs_to :campaign_character
  belongs_to :session
  enum :status, { confirmed: 'confirmed', cancelled: 'cancelled', pending: 'pending'  }
end
