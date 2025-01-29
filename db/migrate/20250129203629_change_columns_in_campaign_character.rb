class ChangeColumnsInCampaignCharacter < ActiveRecord::Migration[7.1]
  def change
    change_column_null :campaign_characters, :character_id, true
    change_column_null :campaign_characters, :hit_points, true
    add_reference :campaign_characters, :user, foreign_key: true
    add_column :campaign_characters, :level, :integer
    add_column :campaign_characters, :invite, :boolean, default: nil
  end
end
