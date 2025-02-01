module SesssionCreationService
  def def initialize(campaign)
    @campaign = campaign
  end

  def create_session
    return {error: " A Company of Adventurers must belong to your campaign to venture forth" } if @campaign.users.empty?

    session = Session.new(@campaign)

    availability_hash = AvailabilityService.get_player_availability
    session.player_availability = availability_hash
    suggestion = availability_hash.sort.first[0]
    session.date = suggestion

    if @session.save
      generate_invites(@session)
      result[:sucess]  notice: "Session created for #{@session.date}. Invites sent successfully."
    else
          result[:error] alert: 'Failed to send invites.'
    end

  end


end
