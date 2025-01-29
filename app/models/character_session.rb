class CharacterSession < ApplicationRecord
  belongs_to :campaign_character
  belongs_to :session
end
