module Schedule
  extend ActiveSupport::Concern

  def get_player_availability(campaign)
    player_availability = {}
    campaign.users.each do |user|
      user.availability.each do |time_slot|
        !(player_availability.include?(time_slot)) ? player_availability[time_slot] = 1 : player_availability[time_slot] += 1
        end
      end
    player_availability
  end

  def generate_session(availability_hash, session)
    if player_availability.empty?
      flash[:alert] = 'None of your players have provided any availability. Try messaging them'
      redirect_to campaign_path(@campaign)
    else
      session.player_availability = player_availability
      suggestion = player_availability.sort.first[0]
      session.date = suggestion
      return session
    end

  def genenerate_invites(session, campaign)
    campaign.campaign_characters.each do |character|
      @character_session = CharacterSession.create(@session, character)
    end
  end



end
