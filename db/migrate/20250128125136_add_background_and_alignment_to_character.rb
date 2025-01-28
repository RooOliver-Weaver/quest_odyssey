class AddBackgroundAndAlignmentToCharacter < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :background, :string
    add_column :characters, :alignment, :string
  end
end
