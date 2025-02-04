class AddPersonalityEquipmentAndTraitsToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :personality, :text
    add_column :characters, :equipment, :jsonb, default: []
    add_column :characters, :traits, :jsonb, default: []
  end
end
