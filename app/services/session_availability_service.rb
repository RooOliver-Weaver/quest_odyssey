class SessionAvailabilityService
  def initialize(campaign)
    @campaign = campaign
    @dm = @campaign.user
  end

  def fetch_player_availability
    response = get_dm_availability
    Rails.logger.debug "DEBUG: Response object class - #{response.class}"
      Rails.logger.debug "DEBUG: Response object keys - #{response.keys}" if response.is_a?(Hash)
      Rails.logger.debug "DEBUG: Response object content - #{response.inspect}"
    if response[:dm_missing]
      (Rails.logger.debug "DEBUG: Is the issue here? #{response} \n\n\n")
      Rails.logger.debug "DEBUG: Response object class - #{response.class}"
      Rails.logger.debug "DEBUG: Response object keys - #{response.keys}" if response.is_a?(Hash)
      Rails.logger.debug "DEBUG: Response object content - #{response.inspect}"
      return response
    else
      player_availability, no_availability = collect_player_availability(response)
      return generate_availability_response(player_availability, no_availability)
    end
  end

  private

  def collect_player_availability(availability_block)
    player_availability = availability_block.dup
    no_availability = []

    @campaign.users.each do |user|
      if user.availability.empty?
        no_availability << user.nickname
         Rails.logger.debug "DEBUG: Received nickname - #{user.nickname}. This SHOULD NOT appear if the player HAVE provided their availability "
      else
        user.availability.each do |time_slot|
          player_availability[time_slot] += 1 if availability_block.dup.has_key?(time_slot)
          Rails.logger.debug "DEBUG: Availabilty Thus Far: #{player_availability}. This SHOULD NOT APPEAR if the players HAVE NOT provided their availability!!"
        end
      end
    end

    player_availability = {} if no_availability.length == @campaign.users.length
    Rails.logger.debug "DEBUG: Response object class - #{player_availability.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{player_availability.keys}" if player_availability.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{player_availability.inspect}"
    Rails.logger.debug "DEBUG: Response object class - #{no_availability.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{no_availability.keys}" if no_availability.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{no_availability.inspect}"

    [player_availability, no_availability]
  end

  def generate_availability_response(player_availability, no_availability)
    Rails.logger.debug "DEBUG: Response object class - #{player_availability.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{player_availability.keys}" if player_availability.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{player_availability.inspect}"
    Rails.logger.debug "DEBUG: Response object class - #{no_availability.class}"
    Rails.logger.debug "DEBUG: Response object keys - #{no_availability.keys}" if no_availability.is_a?(Hash)
    Rails.logger.debug "DEBUG: Response object content - #{no_availability.inspect}"
    if no_availability.any? && no_availability.length == 1
      Rails.logger.debug "DEBUG: Should appear of if ONLY ONE player has not provided their availability"
      return { atleast_one_missing: "The dolt #{no_availability[0]} has failed to provide their availability. Chastise them by messaging them." }
    elsif no_availability.any? && no_availability.length < @campaign.users.length
      Rails.logger.debug "DEBUG: Should appear of if SOME BUT NOT ALL players have not provided their availability"
      return { atleast_one_missing: "# The dolts #{no_availability.join(", ")} have failed to provide their availability. Chastise them by messaging them." }
    elsif no_availability.length == @campaign.users.length
      Rails.logger.debug "DEBUG: Should appear of if ALL PLAYERS have not provided their availability"
      return { all_missing: "What a laggardly group of adventurers you have chosen. None have provided their availability. Chastise them messaging them." }
    else
      Rails.logger.debug "DEBUG: Should appear of if ALL PLAYERS HAVE PROVIDED their availability #{player_availability}"
      return player_availability
    end
  end

  def get_dm_availability
    dm_availability = @dm.availability

    if dm_availability.nil? || dm_availability.empty?
      Rails.logger.debug "DEBUG: Should appear ONLY IF DM has NOT provided their availability"
      return { dm_missing: "Woe to the DM who tries to rally others before they have themselves in order. Please update your availability." }
    else
      Rails.logger.debug "DEBUG: Should appear ONLY IF DM HAS provided their availability #{dm_availability}"
      Rails.logger.debug "DEBUG: Response object class - #{dm_availability.class}"
      Rails.logger.debug "DEBUG: Response object keys - #{dm_availability.keys}" if response.is_a?(Hash)
      Rails.logger.debug "DEBUG: Response object content - #{dm_availability.inspect}"
      dm_availability.each_with_object(Hash.new(0)) { |time_slot, hash| hash[time_slot] = 0 }
    end
  end

end
