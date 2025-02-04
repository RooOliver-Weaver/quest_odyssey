class AddAttacksToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :attacks, :jsonb, default: []
  end
end
