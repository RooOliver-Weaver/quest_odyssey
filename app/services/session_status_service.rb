module SessionStatusService
  def def initialize(session)
    @session = session
  end


  def checkstatusplayers(@session)
    session.character_sessions.each do |charsession|
      if charsession.status.cancelled
        SessionsMessagesService.new(@session).player_unavailable()
        break :exited_early
      end
    end
  update_session_date(@session) if :exited_early
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

end
