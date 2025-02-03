class SessionMessagesService
  def initialize(session)
    @session = session
    dm = @session.campaign.user
  end

  def generate_invites
    @session.campaign.campaign_characters.each do |character|
      @character_session = CharacterSession.create(@session, character)
    end
  end

  def player_unavailable(unavailable_character)

  end

  def get_dm_approval
  end



end
