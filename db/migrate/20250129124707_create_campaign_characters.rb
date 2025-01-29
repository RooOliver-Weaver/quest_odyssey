class CreateCampaignCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :campaign_characters do |t|
      t.references :character, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.integer :hit_points, null: false
      t.jsonb :death_saves
      t.jsonb :inventory
      t.jsonb :stats
      t.timestamps
    end
  end
end
