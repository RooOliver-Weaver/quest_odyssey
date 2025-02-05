class SessionsController < ApplicationController

  def create
    @campaign = Campaign.find(params[:campaign_id])
    result = SessionSchedulerService.new(campaign: @campaign).create_session
    Rails.logger.debug "DEBUG: Response object class - #{result.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{result.keys}" if result.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{result.inspect}"
    if result[:error]
      redirect_to campaign_path(@campaign), alert: result[:error]
    else
      redirect_to campaign_path(@campaign), notice: result[:success]
    end
  end

  def approve
    @session = Session.find(params[:id])
    response = SessionStatusService.new(@session).confirm_session("#{params[:status]}")
    notice_message = []
    notice_message << response[:cancelled] if response[:cancelled].present?
    notice_message << response[:success] if response[:success].present?

    redirect_to campaign_path(@session.campaign), notice: notice_message.join("\n")
  end



end
