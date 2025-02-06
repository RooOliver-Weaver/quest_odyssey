class SessionSchedulerService
  def initialize(campaign: nil, session: nil)
    @session = session
    @campaign = campaign
  end

  def create_session
    return error_response("A Company of Adventurers must belong to your campaign to venture forth") if @campaign.users.empty?

    @session = Session.new(campaign_id: @campaign.id)
    response = SessionAvailabilityService.new(@campaign).fetch_player_availability
    Rails.logger.debug "DEBUG: response object has gone through fetch_player_availability and is back in SessionScedulerService \n"
    Rails.logger.debug "DEBUG: Response object class - #{response.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{response.keys}" if response.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{response.inspect} \n\n"

    result = handle_availability_response(response)
    Rails.logger.debug "DEBUG: Result object class - #{result.class}"
    Rails.logger.debug "DEBUG: Result object keys - #{result.keys}" if result.is_a?(Hash)
    Rails.logger.debug "DEBUG: Result object content - #{result.inspect}"
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
    Rails.logger.debug "DEBUG: Response object is now in handle availability response \n - #{response}"
    Rails.logger.debug "DEBUG: Response object class - #{response.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{response.keys}" if response.is_a?(Hash)
    Rails.logger.debug "DEBUG: Received response content - #{response.inspect}\n\n"

    if response.length == 1 && response[:all_missing].present?
      Rails.logger.debug "DEBUG: All players missing availability - #{response.inspect}\n"
      return error_response(response[:all_missing])
    elsif response.length == 1 && response[:atleast_one_missing].present?
      Rails.logger.debug "DEBUG: At least one player missing availability - #{response.inspect}\n"
      return error_response(response[:atleast_one_missing])
    elsif response.length == 1 && response[:dm_missing].present?
      Rails.logger.debug "DEBUG: DM missing availability - #{response.inspect}\n"
      return error_response(response[:dm_missing])
    end

    unless response.is_a?(Hash) && response.length > 1
      Rails.logger.debug "DEBUG: Invalid response format - #{response.inspect}\n"
      return error_response("Invalid availability data. Please try again.")
    end

    if response.values.all? { |v| v == 0 }
      Rails.logger.debug "DEBUG: All availability values are 0 - #{response.inspect}\n"
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
    Rails.logger.debug "\nDEBUG: Response object is now in Save Availability and Save Date (It should be as an availabilty hash)\n"
    Rails.logger.debug "DEBUG: Response object class - #{response.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{response.keys}" if response.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{response.inspect}\n"
    @session.player_availability = response
    best_date = response.max_by { |_date, votes| votes }&.first
    Rails.logger.debug "DEBUG: Best Date object class - #{best_date.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{best_date.keys}" if best_date.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{best_date.inspect}\n\n"

    unless best_date
      Rails.logger.debug "DEBUG: No best date found - #{response.inspect}"
      return error_response("No suitable date found. Please update availability.")
    end

    @session.date = best_date

    if @session.save
      Rails.logger.debug "DEBUG: @session object being saved now \n"
      Rails.logger.debug "DEBUG: @session object class - #{@session.class}"
      Rails.logger.debug "DEBUG: @session object keys - #{@session.keys}" if @session.is_a?(Hash)
      Rails.logger.debug "DEBUG: @session object content - #{@session.inspect}\n\n"
      SessionMessagesService.new(@session).generate_invites
      success_response("Session created for #{@session.date}. Invites sent.")
    else
      error_response("Failed to create session. Unknown error (Blame the Old Gods).")
    end
  end

  def error_response(message)
    Rails.logger.debug "DEBUG: message object class - #{message.class}\n"
    Rails.logger.debug "DEBUG: message object keys - #{message.keys}" if @session.is_a?(Hash)
    Rails.logger.debug "DEBUG: message object content - #{message.inspect}\n\n"
    { error: message }
  end

  def success_response(message)
    Rails.logger.debug "DEBUG: message object class - #{message.class}\n"
    Rails.logger.debug "DEBUG: message object keys - #{message.keys}" if @session.is_a?(Hash)
      Rails.logger.debug "DEBUG: message object content - #{message.inspect}\n\n"
    { success: message }
  end
end
