class SessionMessagesService
  def initialize(session)
    @session = session
    @dm = @session.campaign.user
    @players = @session.character_sessions.map {|character_session| character_session.campaign_character.user}

  end

  def generate_invites
    @session.campaign.campaign_characters.each do |character|
      @character_session = CharacterSession.create(session_id: @session.id, campaign_character_id: character.id)
    end
  end

  def player_unavailable(unavailable_character)
    message_players = "#{unavailable_character.campaign_character.user.nickname} can not make #{@session.date} for #{@session.campaign.name}"
    @players.each {|player| Notification.create!(user: player, message: message_players)}
    Notification.create!(user: @dm, message: message_players)
    #message_dm = "#{unavailable_character.campaign_character.user.nickname} cannot make the next session. Venture forth anyway?"
    #Message.create!(user: @dm, session: @session, campaign: @session.campaign, content: message_dm, message_type: "dm_approval")
  end

  def all_confirmed
    message = "All players have confirmed #{@session.date} for #{@session.campaign.name}. Rally yourselves."
    @players.each {|player| Notification.create!(user: player, message: message) }
    message_dm = "All players have confirmed #{@session.date} for #{@session.campaign.name}. Check your Dashboard to confirm this date."
    Notification.create!(user: @dm, message: message_dm)
  end

  def session_confirm_or_reject(status)
    message = status == "confirmed" ? "Session Date - #{@session.date} approved by DM!" : "Session - #{@session.date} rejected by DM."
    @players.each {|player| Notification.create!(user: player, message: message) }
    if status == "confirmed"
      message_dm = "Session made for #{@session.date}"
      Notification.create!(user: @dm, message: message_dm)
    end
  end

  def no_date_found
    message = "Unfortunately no date was found for the next session of #{@session.campaign} that met everyone's availability. Try arranging for another week?"
    Notification.create!(user: @dm, message: message)
    @players.each {|player| Notification.create!(user: player, message: message) }
  end


end
