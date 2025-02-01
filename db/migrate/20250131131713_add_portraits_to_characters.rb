class AddPortraitsToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :portrait, :string
  end
end
