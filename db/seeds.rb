require 'json'

Notification.delete_all
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
  character = Character.create!(
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
     stats: char[:stats],
     attacks: char[:attacks],
   )

   if char[:portrait].present?
    portrait_path = Rails.root.join("public/images/#{char[:portrait]}")
      if File.exist?(portrait_path)
        puts "Attaching portrait for #{char[:name]}: #{portrait_path}"
        begin
          character.portrait.attach(
            io: File.open(portrait_path),
            filename: File.basename(portrait_path),
            content_type: "image/jpeg"
          )
          puts "✅ Attached portrait for #{char[:name]}"
        rescue => e
          puts "❌ Failed to attach portrait for #{char[:name]}: #{e.message}"
        end
      else
        puts "❌ File not found: #{portrait_path} for #{char[:name]}"
      end
   else
    puts "⚠️ No portrait provided for #{char[:name]}"
   end

   character
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
  selected_users = []

  rand(3..5).times do
    valid_characters = characters.reject { |char| char.user.id == camp.user.id || selected_users.include?(char.user.id) }
    break if valid_characters.empty?

    character = valid_characters.sample
    selected_users << character.user.id

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
