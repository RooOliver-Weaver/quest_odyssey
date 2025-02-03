class AvailabilityService
  def initialize(campaign)
    @campaign = campaign
  end

  def fetch_player_availability
    player_availability, no_availability = collect_player_availability
    generate_availability_response(player_availability, no_availability)
  end

  private

  def collect_player_availability
    player_availability = Hash.new(0)
    no_availability = []

    @campaign.users.each do |user|
      if user.availability.empty?
        no_availability << user.nickname
      else
        user.availability.each { |time_slot| player_availability[time_slot] += 1 }
      end
    end

    [player_availability, no_availability]
  end

  def generate_availability_response(player_availability, no_availability)
    if no_availability.any? && no_availability.length < @campaign.users.length
      { atleast_one_missing: "#{no_availability.join(", ")} has failed to provide their availability. Chastise them by messaging them." }
    elsif player_availability.empty?
      { all_missing: "None of your players have provided any availability. Try messaging them." }
    else
      player_availability
    end
  end
end
