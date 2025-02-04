class SessionStatusService
  def initialize(session)
    @session = session
  end


  def checkstatusplayers
    confirmed_players = 0

    @session.character_sessions.each do |charsession|
      if charsession.cancelled?
        SessionsMessagesService.new(@session).player_unavailable(charsession)
      elsif charsession.confirmed?
        confirmed_players += 1
      end
    end
    if confirmed_players == @session.character_sessions.length
      SessionMessagesService.new(@session).get_dm_approval
    end

  end

  def confirm_session(status)
    @session.status = status
     if @session.save
      SessionsMessagesService.new(@session).session_confirm_or_reject(status)
      if @session.status.rejected?
        SessionSchedulerService.new(session: @session).update_session_date
        return {sucess: "Session cancelled. Quest Odyssey will try and find the next best slot"}
      else
        return {success: "Session confirmed for #{@session.date}"}
      end
     else
      return {error: "Unknown error. Could not create for #{@session.date} (Blame the Old Gods)"}
     end
  end



end
