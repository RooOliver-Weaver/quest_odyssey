class AddPlayerAvailabilityToSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :player_availability, :jsonb
  end
end
