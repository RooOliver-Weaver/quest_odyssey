class SessionAvailabilityService
  def initialize(campaign)
    @campaign = campaign
    @dm = @campaign.user
  end

  def fetch_player_availability
    response = get_dm_availability
    log_debug("\n DM Availability: #{response} should exist", response)

    if response.length == 1 && response[:dm_missing].present?
      log_debug("\nDEBUG: This should ONLY appear if DM has NOT provided their availability", response)
      return response
    else
      player_availability, no_availability = collect_player_availability(response)
      return generate_availability_response(player_availability, no_availability)
    end
  end

  private

  def collect_player_availability(availability_block)
    log_debug("\nDEBUG: This should ONLY appear if DM HAS provided availability", availability_block)
    player_availability = availability_block.dup
    no_availability = []

    @campaign.users.each do |user|
      if user.availability.empty?
        no_availability << user.nickname
      else
        user.availability.each do |time_slot|
          player_availability[time_slot] += 1 if availability_block.dup.has_key?(time_slot)
        end
      end
    end

    player_availability = {} if no_availability.length == @campaign.users.length
    Rails.logger.debug "DEBUG: Response object class - #{player_availability.class}"
    log_debug("\nDEBUG: Updated Player Availability", player_availability)
    log_debug("\nDEBUG: Players with no Availability", no_availability)

    [player_availability, no_availability]
  end

  def generate_availability_response(player_availability, no_availability)

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
      return player_availability
    end
  end

  def get_dm_availability
    dm_availability = @dm.availability

    if dm_availability.nil? || dm_availability.empty?
      Rails.logger.debug "DEBUG: Should appear ONLY IF DM has NOT provided their availability"
      return { dm_missing: "Woe to the DM who tries to rally others before they have themselves in order. Please update your availability." }
    else
      log_debug("\nDEBUG: If DM has provided their availability", dm_availability)
      dm_availability.each_with_object(Hash.new(0)) { |time_slot, hash| hash[time_slot] = 0 }
    end
  end


  def log_debug(message, object = nil)
    Rails.logger.debug "DEBUG: #{message}"
    Rails.logger.debug "DEBUG: Object class - #{object.class}" if object
    Rails.logger.debug "DEBUG: message object keys - #{object.keys}" if object.is_a?(Hash)
    Rails.logger.debug "DEBUG: Object content - #{object.inspect}\n\n" if object
  end

end
