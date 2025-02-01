class SessionsController < ApplicationController

  def create
    campaign = Campaign.find(params[:campaign_id])
    result = SessionCreationService.new(campaign).create_session
    if result[:error]
      redirect_to campaign_path(campaign), alert: result[:error]
    else
      redirect_to campaign_path(campaign), notice: result[:success]
    end
  end
end
