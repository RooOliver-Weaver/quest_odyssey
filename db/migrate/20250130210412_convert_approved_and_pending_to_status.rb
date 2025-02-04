class ConvertApprovedAndPendingToStatus < ActiveRecord::Migration[7.1]
  def change
    remove_column :sessions, :approved, :boolean
    remove_column :character_sessions, :pending, :boolean
    add_column :sessions, :status, :string, default: 'pending', null: false
    add_column :character_sessions, :status, :string, default: 'pending', null: false
    add_column :sessions, :relay_count, :integer, default: 3
  end
end
