class ChangeStatsToAllowNilAndDefaultEmptyJson < ActiveRecord::Migration[7.1]
  def change
    change_column_default :characters, :stats, {} # set the default value to {}
    change_column_null :characters, :stats, true
  end
end
