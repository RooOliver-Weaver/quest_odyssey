class AddAvailabilityToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :availability, :string, array: true, default: []
  end
end
