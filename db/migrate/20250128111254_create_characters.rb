class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.string :race
      t.string :speciality
      t.integer :level
      t.jsonb :stats
      t.text :biography

      t.timestamps
    end
  end
end
