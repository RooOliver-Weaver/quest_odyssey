class AddCampaignToSessions < ActiveRecord::Migration[7.1]
  def change
    add_reference :sessions, :campaign, null: false, foreign_key: true
  end
end
