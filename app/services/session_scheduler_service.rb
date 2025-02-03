class SessionSchedulerService
  def initialize(campaign)
    @campaign = campaign
  end

  def create_session
    return {error: " A Company of Adventurers must belong to your campaign to venture forth" } if @campaign.users.empty?

    @session = Session.new(campaign_id: @campaign.id)


    response = AvailabilityService.new(@campaign).fetch_player_availability
    p response
    if response[:all_missing].present?
      p "Returning early: all_missing"
      return { error: response[:all_missing] }
      p "Returning early: atleast_one_missing"
    elsif response[:atleast_one_missing].present?
      return { error: response[:atleast_one_missing] }
    else
      p response
      @session.player_availability = response
      suggestion = response.sort.first[0]
      @session.date = suggestion
      if @session.save
        SessionMessagesService.new(@session).generate_invites
        return {success: "Session created for #{@session.date}. Invites sent."}
      else
        return {error: "Failed to create session. Unknown error (Blame the Old Gods)." }
      end
    end

  end






end
