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
    end

  end

  def confirm_session(status)
    @session.status = status
    return { error: "Unknown error. Could not create for #{@session.date} (Blame the Old Gods)" } unless @session.save

    SessionMessagesService.new(@session).session_confirm_or_reject(status)

    if @session.cancelled?
      cancelled = { cancelled: "Session cancelled. Quest Odyssey will try and find the next best slot"}
      response = SessionSchedulerService.new(session: @session).update_session_date
      response = response.merge(cancelled)
      return response
    elsif @session.confirmed?
      return response = { success: "Session confirmed for #{@session.date}" }
    end
  end



end
