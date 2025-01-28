class AddDefaultToActiveInCampaigns < ActiveRecord::Migration[7.1]
  def change
    change_column_default :campaigns, :active, from: nil, to: false
  end
end
