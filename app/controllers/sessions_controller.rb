class SessionsController < ApplicationController

  def create
    @campaign = Campaign.find(params[:campaign_id])
    result = SessionSchedulerService.new(campaign: @campaign).create_session
    if result[:error]
      redirect_to campaign_path(@campaign), alert: result[:error]
    else
      redirect_to campaign_path(@campaign), notice: result[:success]
    end
  end

  def approve
    @session = Session.find(params[:id])
    response = SessionStatusService.new(session: @session).confirm_session(params[:status])
    redirect_to dashboard_path, notice: response[:success]
  end



end
