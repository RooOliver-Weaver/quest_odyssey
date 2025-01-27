class CreateCampaigns < ActiveRecord::Migration[7.1]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :setting
      t.text :description
      t.date :next_session
      t.references :user, null: false, foreign_key: true
      t.text :notes
      t.boolean :active
      t.text :dm_notes

      t.timestamps
    end
  end
end
