module SessionSchedulerService
  def def initialize(session)
    @session = session
  end




  def checkstatusplayers(@session)
    session.character_sessions.each do |charsession|
      break :exited_early if charsession.status.rejected
    end
    update_session_date(@session) if :exited_early
  end

  def update_session_date(@session)
    @session.relay_count =-1
    if @session.relay_count == 0
      @session.destroy!
        #sends a message to the DM and players that a schedule
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






end
