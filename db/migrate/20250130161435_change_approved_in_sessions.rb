class ChangeApprovedInSessions < ActiveRecord::Migration[7.1]
  def change
    change_column_null :sessions, :approved, true, default: nil
  end
end
