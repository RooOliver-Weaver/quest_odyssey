class AvailabilityService
  def initialize(campaign)
    @campaign = campaign
  end

  def fetch_player_availability
    player_availability, no_availability = collect_player_availability
    response = generate_availability_response(player_availability, no_availability)
    p response
    return response
  end

  private

  def collect_player_availability
    player_availability = Hash.new(0)
    no_availability = []
    p @campaign.users
    @campaign.users.each do |user|
      if user.availability.empty?
        no_availability << user.nickname
      else
        user.availability.each { |time_slot| player_availability[time_slot] += 1 }
      end
    end
    return [player_availability, no_availability]
  end

  def generate_availability_response(player_availability, no_availability)
    if no_availability.any? && no_availability.length < @campaign.users.length
       return { atleast_one_missing: "#{no_availability.join(", ")} has failed to provide their availability. Chastise them by messaging them." }
    elsif player_availability.empty?
      return { all_missing: "None of your players have provided any availability. Try messaging them." }
    else
      return player_availability
    end
  end
end
