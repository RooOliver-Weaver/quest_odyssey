require 'json'

Message.delete_all
CampaignCharacter.delete_all
CharacterSession.delete_all
Campaign.delete_all
Character.delete_all
User.delete_all

users = User.create!([

  { email: "dm@example.com", password: "password123", nickname: "CriticalHitKing" },
  { email: "player1@example.com", password: "password123", nickname: "DungeonDelver77" },
  { email: "player2@example.com", password: "password123", nickname: "ArcaneArchitect" },
  { email: "player3@example.com", password: "password123", nickname: "StealthyDagger"  },
  { email: "test@test.com", password: "password", nickname: "MysticMapper"  },
  { email: "player4@example.com", password: "password123", nickname: "SirRollsALot" }
])

puts "Created #{users.count} users."

file = File.read(Rails.root.join('db/characters.json'))
character_data = JSON.parse(file, symbolize_names: true)

characters = character_data.map do |char|
  Character.create!(
     name: char[:name],
     race: char[:race],
     speciality: char[:speciality],
     level: char[:level],
     biography: char[:biography],
     alignment: char[:alignment],
     background: char[:background],
     user: users.sample,
     personality: char[:personality],
     equipment: char[:equipment],
     traits: char[:traits],
     attacks: char[:attacks],
     stats: char[:stats]
   )
end

puts "Created #{characters.count} characters."

file = File.read(Rails.root.join('db/campaigns.json'))
campaign_data = JSON.parse(file, symbolize_names: true)

campaigns = campaign_data.map do |camp|
  Campaign.create!(
    name: camp[:name],
    setting: camp[:setting],
    description: camp[:description],
    notes: camp[:player_notes],
    dm_notes: camp[:dm_notes],
    user: users.sample,
    next_session: Date.today + rand(1..30),
    active: [true, false].sample,
    public: [true, false].sample,
  )
end

puts "Created #{campaigns.count} campaigns."

campaign_characters = campaigns.sample(6).map do |camp|
  5.times do
    valid_characters = characters.reject { |char| char.user.id == camp.user.id }
    next if valid_characters.empty?

    character = valid_characters.sample
    CampaignCharacter.create!(
      campaign: camp,
      character: character,
      hit_points: rand(20..30),
      user: character.user,
      level: character.level,
      invite: false,
      death_saves: { successes: 0, failures: 0 },
      inventory: character.equipment,
      stats: character.stats
    )
  end
end

puts "Assigned characters to campaigns."
