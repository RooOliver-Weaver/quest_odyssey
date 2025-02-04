class AddPersonalNotesToCampaignCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :campaign_characters, :personal_notes, :text
  end
end
