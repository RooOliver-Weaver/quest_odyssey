class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :character, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true
      t.integer :hit_points
      t.string :death_saves
      t.text :inventory
      t.jsonb :stats

      t.timestamps
    end
  end
end
