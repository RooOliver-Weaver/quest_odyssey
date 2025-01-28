# Clear existing data
Campaign.delete_all
Character.delete_all
User.delete_all

# Create users
users = User.create!([
  { email: "dm@example.com", password: "password123" },
  { email: "player1@example.com", password: "password123" },
  { email: "player2@example.com", password: "password123" },
  { email: "player3@example.com", password: "password123" }
])

puts "Created #{users.count} users."

# Generate sample character data
character_data = [
  { name: "Thalion", race: "Elf", speciality: "Ranger", level: 5, biography: "An elf who guards the forests." },
  { name: "Gorak", race: "Half-Orc", speciality: "Barbarian", level: 4, biography: "A fierce warrior seeking redemption." },
  { name: "Lila", race: "Halfling", speciality: "Rogue", level: 3, biography: "A mischievous thief with a golden heart." },
  { name: "Myrin", race: "Tiefling", speciality: "Sorcerer", level: 6, biography: "A magic user with an infernal heritage." },
  { name: "Eldon", race: "Human", speciality: "Cleric", level: 7, biography: "A healer devoted to a sun god." },
  { name: "Kael", race: "Dragonborn", speciality: "Paladin", level: 8, biography: "A holy knight with draconic blood." },
  { name: "Zara", race: "Dwarf", speciality: "Fighter", level: 4, biography: "A stout warrior who loves her ale." },
  { name: "Fenris", race: "Gnome", speciality: "Wizard", level: 5, biography: "A genius inventor and spellcaster." },
  { name: "Rurik", race: "Dwarf", speciality: "Bard", level: 2, biography: "A storyteller spreading tales of heroism." },
  { name: "Selene", race: "Elf", speciality: "Druid", level: 6, biography: "A protector of the natural world." }
]

# Create characters
characters = character_data.map do |char|
  Character.create!(
    char.merge(
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
  )
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
