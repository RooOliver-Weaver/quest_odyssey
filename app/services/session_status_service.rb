class SessionStatusService
  def def initialize(session)
    @session = session
  end


  def checkstatusplayers(@session)
    session.character_sessions.each do |charsession|
      if charsession.status.cancelled
        SessionsMessagesService.new(@session).player_unavailable(charsession)
        break :exited_early
      elsif charsession.status.confirmed
        confirmed_players += 1
      end
    end
    if confirmed_players.length == session.character_sessions.length
      SessionMessagesService.new(@session).get_dm_approval
   elsif :exited_early
    SessionsMessagesService.new(@session).player_unavailable(charsession)
    update_session_date(@session)
   end

  end

  def confirm_session(status)
    @session.status = status
    @session.save
    if @session.status.confirmed
      SessionsMessagesService.new(@session).session_confirmed
    elsif @session.status.rejected
      SessionsMessagesService.new(@session).session_rejected




  end

  def update_session_date(@session)
    @session.relay_count =- 1
    if @session.relay_count == 0
      @session.destroy!
      SessionMessagesService.new(@session).no_date_found
    else
      new_availabity = @session.player_availability.delete(@session.player_availability.player_availability.sort.first[0])
      @session.player_availability= new_availabity
      @suggestion = player_availability.sort.first[0]
      @session.date = suggestion
      if @session.save
        @session.character_session {|charsession| charsession.destroy!}
        genenerate_invites(@session)
      end
    end

    private



end
