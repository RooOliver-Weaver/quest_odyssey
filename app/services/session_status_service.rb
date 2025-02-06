class SessionStatusService
  def initialize(session)
    @session = session
  end


  def checkstatusplayers
    confirmed_players = 0

    @session.character_sessions.each do |charsession|
      if charsession.cancelled?
        SessionMessagesService.new(@session).player_unavailable(charsession)
      elsif charsession.confirmed?
        confirmed_players += 1
      end
    end
    if confirmed_players == @session.character_sessions.length
      SessionMessagesService.new(@session).all_confirmed
      @session.update!(status: "confirmed")
    end

  end

  def confirm_session(status)
    @session.status = status
    return { error: "Unknown error. Could not create for #{@session.date} (Blame the Old Gods)" } unless @session.save

    SessionMessagesService.new(@session).session_confirm_or_reject(status)

    if @session.cancelled?
      cancelled = { cancelled: "Session cancelled. Quest Odyssey will try and find the next best slot"}
      update_char_sessions_to cancel
      response = SessionSchedulerService.new(session: @session).update_session_date
      if response == nil
        cancelled = {cancelled: "Last Session Cancelled. We recommend that the DM makes a new session with the players' updated availabilites."}
      else
        response = response.merge(cancelled)
        return response
      end
    elsif @session.confirmed?
      return response = { success: "Session confirmed for #{@session.date}" }
    end
  end

  def update_char_sessions_to_pen
    @session.campaign.users.each do |user|
      user.campaign_characters.each do |campaign_character|
        existing_character_session = CharacterSession.find_by(session: @session, campaign_character: campaign_character)
        if existing_character_session
          existing_character_session.update!(status: "pending")
        else
          CharacterSession.create!(
            session: @session,
            campaign_character: campaign_character, # Assign the correct character
            status: "pending"
          )
        end
      end
    end
  end



  private

  def update_char_sessions_to_cancel
    @session.character_sessions.each do |character_session|
      character_session.update!(status: "cancelled") # Ensure status update is correct
    end
  end






end
