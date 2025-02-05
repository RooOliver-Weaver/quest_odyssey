class SessionSchedulerService
  def initialize(campaign: nil, session: nil)
    @session = session
    @campaign = campaign
  end

  def create_session
    return error_response("A Company of Adventurers must belong to your campaign to venture forth") if @campaign.users.empty?

    @session = Session.new(campaign_id: @campaign.id)
    response = SessionAvailabilityService.new(@campaign).fetch_player_availability

    handle_availability_response(response)
  end

  def update_session_date
    @session.relay_count -= 1

    if @session.relay_count.zero?
      @session.destroy!
      SessionMessagesService.new(@session).no_date_found
    else
      reschedule_session
    end
  end

  private

  def handle_availability_response(response)
    return save_session_availability_and_date(response) if response.is_a?(Hash) && response.length > 1
    return error_response(response[:all_missing]) if response[:all_missing].present?
    return error_response(response[:atleast_one_missing]) if response[:atleast_one_missing].present?
    return error_response(response[:dm_missing]) if response[:dm_missing].present?
  end

  def reschedule_session
    best_date = @session.player_availability.max_by { |_date, votes| votes }&.first
    return unless best_date

    @session.player_availability.delete(best_date)
    save_session_availability_and_date(@session.player_availability)
  end

  def save_session_availability_and_date(response)
    @session.player_availability = response
    @session.date = response.max_by { |_date, votes| votes }&.first

    if @session.save
      SessionMessagesService.new(@session).generate_invites
      success_response("Session created for #{@session.date}. Invites sent.")
    else
      error_response("Failed to create session. Unknown error (Blame the Old Gods).")
    end
  end

  def error_response(message)
    { error: message }
  end

  def success_response(message)
    { success: message }
  end
end
