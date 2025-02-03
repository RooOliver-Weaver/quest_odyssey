module SesssionSchedulerService
  def def initialize(campaign)
    @campaign = campaign
  end

  def create_session
    return {error: " A Company of Adventurers must belong to your campaign to venture forth" } if @campaign.users.empty?

    session = Session.new(@campaign)

    response = AvailabilityService.fetch_player_availability
    if response[:atleast_one_missing]
      redirect_to campaign_path(campaign), alert: response[:atleast_one_missing]
    elsif response[:all_missing]
      redirect_to campaign_path(campaign), alert: response[:all_missing]
    else
      session.player_availability = availability_hash
      suggestion = availability_hash.sort.first[0]
      session.date = suggestion
      if @session.save
        generate_invites(@session)
        {sucess: "Session created for #{@session.date}. Invites sent successfully."}
      else
        result[:error] = 'Failed to create session. Unknown error'
      end
    end

  end






end
