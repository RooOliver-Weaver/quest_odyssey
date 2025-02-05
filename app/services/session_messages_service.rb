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
    message_dm = "#{unavailable_character.campaign_character.user.nickname} cannot make the next session. Venture forth anyway?"
    Message.create!(user: @dm, session: @session, campaign: @session.campaign, content: message_dm, message_type: "dm_approval")
    message_players = "#{unavailable_character.campaign_character.user.nickname} can not make #{@session.date} for #{@session.campaign}"
    @players.each {|player| Message.create!(user: player, session: @session, campaign: @session.campaign, content: message_players, message_type: "player_notifcation")}
  end

  def get_dm_approval
    message = "All players have confirmed #{@session.date}. Do you approve this session?"
    Message.create!(user: @dm, session: @session, campaign: @session.campaign, content: message, message_type: "dm_approval")
  end

  def session_confirm_or_reject(status)
    message = status == "confirmed" ? "Session Date - #{@session.date} approved by DM!" : "Session - #{@session.date} rejected by DM."
    @players.each {|player| Message.create!(user: player, session: @session, campaign: @session.campaign, content: message, message_type: "player_notification") }
  end

  def no_date_found
    message = "Unfortunately no date was found for the next session of #{@session.campaign} that met everyone's availability. Try arranging for another week?"
    Message.create!(user: @dm, session: @session, content: message, message_type: "player_notification")
    @players.each {|player| Message.create!(user: player, session: @session, campaign: @session.campaign, content: message, message_type: "player_notification") }
  end


end
