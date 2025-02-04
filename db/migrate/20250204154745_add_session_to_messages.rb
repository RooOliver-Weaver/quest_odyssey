class AddSessionToMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :messages, :session, foreign_key: true
  end
end
