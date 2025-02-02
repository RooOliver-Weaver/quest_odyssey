require 'open-uri'

# Clear existing data
CampaignCharacter.delete_all
CharacterSession.delete_all
Campaign.delete_all
Character.delete_all
User.delete_all

# Create users
users = User.create!([

  { email: "dm@example.com", password: "password123", nickname: "CriticalHitKing" },
  { email: "player1@example.com", password: "password123", nickname: "DungeonDelver77" },
  { email: "player2@example.com", password: "password123", nickname: "ArcaneArchitect" },
  { email: "player3@example.com", password: "password123", nickname: "StealthyDagger"  },
  { email: "test@test.com", password: "password", nickname: "MysticMapper"  }

])

puts "Created #{users.count} users."

# Generate sample character data
character_data = [

  { name: "Thalion", race: "Elf", speciality: "Ranger", level: 5, biography: "An elf who guards the forests.", alignment: "Neutral Good", background: "Steward of the Forest", portrait: "db/character_portraits/thalion.webp" },
  { name: "Gorak", race: "Half-Orc", speciality: "Barbarian", level: 4, biography: "A fierce warrior seeking revenge.", alignment: "Lawful Evil", background: "Tyrannical Overlord",  portrait: "db/character_portraits/gorak.webp"},
  { name: "Lila", race: "Halfling", speciality: "Rogue", level: 3, biography: "A mischievous thief with a golden heart.", alignment: "Chaotic Neutral", background: "Wandering Trickster", portrait: "db/character_portraits/lila.webp"},
  { name: "Myrin", race: "Tiefling", speciality: "Sorcerer", level: 6, biography: "A magic user with an infernal heritage.", alignment: "Chaotic Good", background: "Reformed Outlaw", portrait: "db/character_portraits/myrin.png" },
  { name: "Eldon", race: "Human", speciality: "Cleric", level: 7, biography: "A healer devoted to a sun god.", alignment:"Lawful Good", background: "Cleric of the Radiant Order", portrait: "db/character_portraits/eldon.png" },
  { name: "Kael", race: "Dragonborn", speciality: "Paladin", level: 8, biography: "A holy knight with draconic blood.", alignment:"Lawful Neutral", background: "Draconic Templars", portrait: "db/character_portraits/kael.jpg" },
  { name: "Zara", race: "Dwarf", speciality: "Fighter", level: 4, biography: "A stout warrior who loves her ale.", alignment: "Neutral Good", background: "The Wayward Mercenaries", portrait: "db/character_portraits/zara.png" },
  { name: "Fenris", race: "Gnome", speciality: "Wizard", level: 5, biography: "A genius inventor and spellcaster.", alignment: "True Neutral", background: "Head of the Enigmatech Guild", portrait: "db/character_portraits/fenris.png"},
  { name: "Rurik", race: "Dwarf", speciality: "Bard", level: 2, biography: "A wandering bard, with a shadowy past who delights in shocking listeners with tales of violence.", alignment: "Neutral Evil", background: "Bloodstained Assassin", portrait: "db/character_portraits/rurik.png" },
  { name: "Selene", race: "Elf", speciality: "Druid", level: 6, biography: "Once a protector of the natural world, now demented with anger against those who wrong the natural world.", alignment: "Chaotic Evil", background: "Deranged Cult Leader", portrait: "db/character_portraits/selene.png" }
]

# Create characters
characters = character_data.map do |char|
   new_character = Character.create!(
      name: char[:name],
      race: char[:race],
      speciality: char[:speciality],
      level: char[:level],
      biography: char[:biography],
      alignment: char[:alignment],
      background: char[:background],
      user: users.sample,
      stats: {
        strength: rand(8..18),
        dexterity: rand(8..18),
        constitution: rand(8..18),
        intelligence: rand(8..18),
        wisdom: rand(8..18),
        charisma: rand(8..18)
      }
    )
  p "#{new_character.name} has been added by #{new_character.user}"
  if (new_character.portrait.attach(
    io: File.open(char[:portrait]),
    filename: File.basename(char[:portrait])
    ) )
    p "Portait has been sucessfully added to #{new_character.name}"
  else
    p "Unsucessful attempt at adding portait to #{new_character.name}"
  end
end

puts "Created #{characters.count} characters."

# Generate sample campaign data
campaign_data = [
  { name: "The Lost Relic", setting: "Forgotten Realms", description: "A journey to find an ancient artifact." },
  { name: "Shadows of the Abyss", setting: "Greyhawk", description: "Fighting the forces of darkness." },
  { name: "The Crimson Tide", setting: "Eberron", description: "Battling pirates and sea monsters." },
  { name: "The Eternal Forest", setting: "Faerûn", description: "Protecting a magical forest from corruption." },
  { name: "The Iron Citadel", setting: "Dark Sun", description: "Storming an impenetrable fortress." },
  { name: "Whispers of the Void", setting: "Ravenloft", description: "Investigating a cursed village." },
  { name: "The Emerald Crown", setting: "Greyhawk", description: "Uncovering a royal conspiracy." },
  { name: "The Arcane War", setting: "Forgotten Realms", description: "Stopping a war between mages." },
  { name: "Fury of the Wilds", setting: "Eberron", description: "Fending off monstrous invasions." },
  { name: "The Frozen Spire", setting: "Faerûn", description: "Climbing a frozen mountain to stop a blizzard." }
]

# Create campaigns
campaigns = campaign_data.map do |camp|
  Campaign.create!(
    camp.merge(
      user: users.first, # Assign all to the DM user
      notes: "Sample notes for #{camp[:name]}",
      dm_notes: "DM-only notes for #{camp[:name]}",
      next_session: Date.today + rand(1..30),
      active: [true, false].sample
    )
  )
end

puts "Created #{campaigns.count} campaigns."
