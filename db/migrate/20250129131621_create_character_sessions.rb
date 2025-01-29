class CreateCharacterSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :character_sessions do |t|
      t.references :campaign_character, null: false, foreign_key: true
      t.references :session, null: false, foreign_key: true
      t.boolean :pending

      t.timestamps
    end
  end
end
