class SessionsController < ApplicationController
  def create
    @campaign = Campaign.find(params[:campaign_id])
    @session = Session.new(campaign_id: @campaign.id )
    if @campaign.users.length >= 1
      availability_hash = player_availability(@campaign)
      @session = generate_session(availability_hash, @session)
      if @session.save
          generate_invites(@session)
        redirect_to campaign_path(@campaign), notice: "Session created for #{@session.date}. Invites sent successfully."
        else
          redirect_to campaign_path(@campaign), alert: 'Failed to send invites.'
        end
      end
    else
      flash[:alert] = 'Please invite players to the Campaign in order to create a session.'
      redirect_to campaign_path(@campaign)
    end
  end
end
