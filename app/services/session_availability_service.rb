class SessionAvailabilityService
  def initialize(campaign)
    @campaign = campaign
    @dm = @campaign.user
  end

  def fetch_player_availability
    response = get_dm_availability
    return response if response.is_a?(Hash) && response[:dm_missing]

    availability_block = response
    player_availability, no_availability = collect_player_availability(availability_block)
    generate_availability_response(player_availability, no_availability)
  end

  private

  def collect_player_availability(availability_block)
    player_availability = availability_block
    no_availability = []

    @campaign.users.each do |user|
      if user.availability.empty?
        no_availability << user.nickname
      else
        user.availability.each do |time_slot|
          player_availability[time_slot] += 1 if availability_block.has_key?(time_slot)
        end
      end
    end

    [player_availability, no_availability]
  end

  def generate_availability_response(player_availability, no_availability)
    if no_availability.any? && no_availability.length < @campaign.users.length
      { atleast_one_missing: "# The dolts #{no_availability.join(", ")} have failed to provide their availability. Chastise them by messaging them." }
    elsif no_availability.any? && no_availability.length == 1
      { atleast_one_missing: " The dolt #{no_availability[0]} has failed to provide their availability. Chastise them by messaging them." }
    elsif no_availability.length == @campaign.users.length
      { all_missing: "What a laggardly group of adventurers you have chosen. None have provided their availability. Chastise them messaging them." }
    else
      player_availability
    end
  end

  def get_dm_availability
    dm_availability = @dm.availability
    return { dm_missing: "Woe to the DM who tries to rally others before they have themselves in order. Please update your availability." } if dm_availability.empty?

    availability_block = Hash.new(0)
    dm_availability.each { |time_slot| availability_block[time_slot] = 0 }
    availability_block
  end


end
