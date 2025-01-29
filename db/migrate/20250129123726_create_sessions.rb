class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.boolean :approved, default: false
      t.string :date
      t.timestamps
    end
  end
end
