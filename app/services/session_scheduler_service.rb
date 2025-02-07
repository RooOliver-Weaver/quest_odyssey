class SessionSchedulerService
  def initialize(campaign: nil, session: nil)
    @session = session
    @campaign = campaign
  end

  def create_session
    return error_response("A Company of Adventurers must belong to your campaign to venture forth") if @campaign.users.empty?

    @session = Session.new(campaign_id: @campaign.id)
    response = SessionAvailabilityService.new(@campaign).fetch_player_availability
    log_debug("\nResponse object after availability fetch", response)

    result = handle_availability_response(response)
    log_debug("\nResponse object after handle_availability", response)
    return result
  end

  def update_session_date
    @session.relay_count -= 1
    if @session.relay_count.zero?
      @session.destroy!
      SessionMessagesService.new(@session).no_date_found
      return nil
    else
      reschedule_session
    end
  end


  private

  def handle_availability_response(response)
    response = response.deep_dup
    log_debug("\nResponse object while in handle_availability", response)

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
    log_debug("\nPlayer Availability while in reschedule_session",@session.player_availability)
    log_debug("\n Date to be removed while in reschedule session",best_date)
    return  error_response("No more available time slots found. Players should update availability.") unless best_date


    new_player_availability = @session.player_availability.tap { |h| h.delete(best_date) }
    log_debug("\nPlayer Availability updates",new_player_availability)

    save_session_availability_and_date(new_player_availability)
  end

  def save_session_availability_and_date(response)
    log_debug("\nPlayer Availability in the save session method",response)
    @session.player_availability = response
    best_date = response.max_by { |_date, votes| votes }&.first
    log_debug("\n Best Date in save session ", best_date)


    unless best_date
      Rails.logger.debug "DEBUG: No best date found - #{best_date.inspect}"
      @session.destroy!
      return error_response("No suitable date found. Please tell players to update their availability.")
    end

    day_and_timeslot = best_date.split
    timeslot = day_and_timeslot.last # “morning”, “midday”, or “evening”
    session_date = Date.parse(best_date)

    if session_date <= Date.today
      session_date = session_date + 1.week
    end

    new_date_str = session_date.strftime('%A, %d %b %Y') + " " + timeslot.to_s
best_date = new_date_str


    @session.date = best_date
    @session.status = "pending"

    if @session.save!
      log_debug("\n #{@sesion} has now been saved",@session)
      if @session.character_sessions.empty?
        SessionMessagesService.new(@session).generate_invites
      else
        @session.character_sessions.each do |character_session|
          character_session.update!(status: "pending")  # Use update! instead of save!
        end
      end

      success_response("Session created for #{session_date.strftime('%A, %d %b %Y')} at #{timeslot}. Invites sent.")
    else
      return error_response("Failed to create session. Unknown error (Blame the Old Gods).")
    end
  end

  def error_response(message)
    log_debug("\n Error Message: #{message} in error response", message)

    { error: message }
  end

  def success_response(message)
    log_debug("\n Sucess Message: #{message} in success response", message)
    { success: message }
  end

  def log_debug(message, object = nil)
    Rails.logger.debug "DEBUG: #{message}"
    Rails.logger.debug "DEBUG: Object class - #{object.class}" if object
    Rails.logger.debug "DEBUG: message object keys - #{object.keys}" if object.is_a?(Hash)
    Rails.logger.debug "DEBUG: Object content - #{object.inspect}\n\n" if object
  end

end
