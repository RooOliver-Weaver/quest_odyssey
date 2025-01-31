class CharacterSession < ApplicationRecord
  belongs_to :campaign_character
  belongs_to :session
  enum :status, { approved: 'approved', rejected: 'rejected', pending: 'pending' }
end
