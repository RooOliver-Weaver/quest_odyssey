class AddPublicToCampaigns < ActiveRecord::Migration[7.1]
  def change
    add_column :campaigns, :public, :boolean
  end
end
