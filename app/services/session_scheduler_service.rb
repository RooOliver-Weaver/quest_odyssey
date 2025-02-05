class SessionSchedulerService
  def initialize(campaign: nil, session: nil)
    @session = session
    @campaign = campaign
  end

  def create_session
    return error_response("A Company of Adventurers must belong to your campaign to venture forth") if @campaign.users.empty?

    @session = Session.new(campaign_id: @campaign.id)
    response = SessionAvailabilityService.new(@campaign).fetch_player_availability
      Rails.logger.debug "DEBUG: Response object class - #{response.class}"
      Rails.logger.debug "DEBUG: Response object keys - #{response.keys}" if response.is_a?(Hash)
      Rails.logger.debug "DEBUG: Response object content - #{response.inspect}"

    result = handle_availability_response(response)
    Rails.logger.debug "DEBUG: Response object class - #{result.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{result.keys}" if result.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{result.inspect}"
    return result
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
    # Create a deep copy of the response object to avoid unintended modifications
    response = response.deep_dup

    Rails.logger.debug "DEBUG: Response object class - #{response.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{response.keys}" if response.is_a?(Hash)
    Rails.logger.debug "DEBUG: Received response in scheduler - #{response.inspect}"

    if response[:all_missing].present?
      Rails.logger.debug "DEBUG: All players missing availability - #{response[:all_missing]}"
      return error_response(response[:all_missing])
    elsif response[:atleast_one_missing].present?
      Rails.logger.debug "DEBUG: At least one player missing availability - #{response[:atleast_one_missing]}"
      return error_response(response[:atleast_one_missing])
    elsif response[:dm_missing].present?
      Rails.logger.debug "DEBUG: DM missing availability - #{response[:dm_missing]}"
      return error_response(response[:dm_missing])
    end

    unless response.is_a?(Hash) && response.length > 1
      Rails.logger.debug "DEBUG: Invalid response format - #{response.inspect}"
      return error_response("Invalid availability data. Please try again.")
    end

    if response.values.all? { |v| v == 0 }
      Rails.logger.debug "DEBUG: All availability values are 0 - #{response.inspect}"
      return error_response("No available time slots found. Please update availability.")
    end

    save_session_availability_and_date(response)
  end



  def reschedule_session
    best_date = @session.player_availability.max_by { |_date, votes| votes }&.first
    return  error_response("No more available time slots found. Players should update availability.") unless best_date

    @session.player_availability.delete(best_date)
    save_session_availability_and_date(@session.player_availability)
  end

  def save_session_availability_and_date(response)
    Rails.logger.debug "DEBUG: Response object class - #{response.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{response.keys}" if response.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{response.inspect}"
    @session.player_availability = response
    best_date = response.max_by { |_date, votes| votes }&.first
    Rails.logger.debug "DEBUG: Response object class - #{best_date.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{best_date.keys}" if best_date.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{best_date.inspect}"

    unless best_date
      Rails.logger.debug "DEBUG: No best date found - #{response.inspect}"
      return error_response("No suitable date found. Please update availability.")
    end

    @session.date = best_date

    if @session.save
      Rails.logger.debug "DEBUG: Response object class - #{@session.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{@session.keys}" if @session.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{@session.inspect}"
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
