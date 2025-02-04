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
    p "Poopy Poopy Poopy #{params[:status]}"
    response = SessionStatusService.new(@session).confirm_session("#{params[:status]}")
    if response[:cancelled].exists? && response[:success].exists?
      redirect_to campaign_path(@session.campaign), notice: response[:cancelled]
      redirect_to campaign_path(@session.campaign), notice: response[:success]
    elsif response[:cancelled].exists?
      redirect_to campaign_path(@session.campaign), notice: response[:cancelled]
      redirect_to campaign_path(@session.campaign), notice: response[:success]
    else
      redirect_to campaign_path(@session.campaign), notice: response[:success]
    end
  end



end
