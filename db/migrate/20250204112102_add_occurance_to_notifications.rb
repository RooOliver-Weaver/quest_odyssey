class AddOccuranceToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :occurrence_count, :integer, default: 1
  end
end
