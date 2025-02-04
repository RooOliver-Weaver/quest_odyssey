class SessionSchedulerService
  def initialize(campaign: nil, session: nil)
    @session = session
    @campaign = campaign
  end

  def create_session
    return {error: " A Company of Adventurers must belong to your campaign to venture forth" } if @campaign.users.empty?

    @session = Session.new(campaign_id: @campaign.id)


    response = AvailabilityService.new(@campaign).fetch_player_availability
    if response.length > 1
      save_session_availability_and_date(response)
    elsif response[:all_missing].present?
      p "Returning early: all_missing"
      return { error: response[:all_missing] }
    elsif response[:atleast_one_missing].present?
       p "Returning early: atleast_one_missing"
      return { error: response[:atleast_one_missing] }
    end
  end


  def update_session_date
    @session.relay_count =- 1
    if @session.relay_count == 0
      @session.destroy!
      SessionMessagesService.new(@session).no_date_found
    else
      response = @session.player_availability.delete(@session.player_availability.player_availability.sort.first[0])
      save_session_availability_and_date(response)
    end
  end

  private

    def save_session_availability_and_date(response)
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
