class CampaignsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @campaigns = Campaign.all
  end

  def show
    @campaign = Campaign.find(params[:id])
  end
end
