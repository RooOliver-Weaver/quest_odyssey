module SessionMessagesService
  def initialize(session)
    @session = session
  end

  def genenerate_invites(@session)
    @session.campaign.campaign_characters.each do |character|
      @character_session = CharacterSession.create(@session, character)
    end
  end

end
