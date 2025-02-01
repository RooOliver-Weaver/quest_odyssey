class AvailabilityService
  def initialize(campaign)
  @campaign = campaign
  end


  def get_player_availability
    player_availability = {}
    @campaign.users.each do |user|
      user.availability.each do |time_slot|
        !(player_availability.include?(time_slot)) ? player_availability[time_slot] = 1 : player_availability[time_slot] += 1
      end
    end
    player_availability
  end
end
