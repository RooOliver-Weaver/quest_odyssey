class SessionsController < ApplicationController
  def create
    @campaign = Campaign.find(params[:campaign_id])
    @session = Session.new(campaign_id: @campaign.id )

    p @campaign.users
    player_availability = {}
    @campaign.users.each do |user|
      user.availability.each do |time_slot|
        !(player_availability.include?(time_slot)) ? player_availability[time_slot] = 1 : player_availability[time_slot] += 1
      end
    end
      p player_availability
      # p player_availability.sort.first[0]
      if player_availability.empty?
        flash[:alert] = 'None of your players have provided any availability. Try messaging them'
        redirect_to campaign_path(@campaign)
      else
        @session.player_availability = player_availability
        suggestion = player_availability.sort.first[0]
        @session.date = suggestion
        if @session.save
          redirect_to campaign_path(@campaign), notice: "Session created for #{suggestion}. Invites sent successfully."
        else
          render 'campaigns/show', alert: 'Failed to send invites.'
        end
      end
  end
end
