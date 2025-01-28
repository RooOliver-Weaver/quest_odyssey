# Clear existing data
Campaign.delete_all
Character.delete_all
User.delete_all

# Create users
users = User.create!([
  { email: "dm@example.com", password: "password123" },
  { email: "player1@example.com", password: "password123" },
  { email: "player2@example.com", password: "password123" }
])

puts "Created #{users.count} users."

# Create characters
characters = Character.create!([
  {
    name: "Thalion",
    user: users[1],
    race: "Elf",
    speciality: "Ranger",
    level: 5,
    stats: { strength: 12, dexterity: 18, constitution: 14, intelligence: 10, wisdom: 15, charisma: 11 },
    biography: "An elf who guards the forests and fights for nature."
  },
  {
    name: "Gorak",
    user: users[2],
    race: "Half-Orc",
    speciality: "Barbarian",
    level: 4,
    stats: { strength: 18, dexterity: 12, constitution: 16, intelligence: 8, wisdom: 10, charisma: 9 },
    biography: "A fierce warrior with a tragic past, seeking redemption."
  }
])

puts "Created #{characters.count} characters."

# Create campaigns
Campaign.create!([
  {
    name: "The Lost Relic",
    setting: "Forgotten Realms",
    description: "A perilous journey to find an ancient artifact.",
    next_session: Date.today + 7,
    user: users[0], # DM
    notes: "Prepare the dungeon map and NPC dialogue.",
    dm_notes: "The artifact is cursed; it should be revealed gradually.",
    active: true
  },
  {
    name: "Shadows of the Abyss",
    setting: "Greyhawk",
    description: "A fight against the forces of darkness threatening the land.",
    next_session: Date.today + 14,
    user: users[0], # DM
    notes: "Introduce the rival adventuring party.",
    dm_notes: "The rival adventuring party will challenge the group.",
    active: false
  }
])

puts "Created #{Campaign.count} campaigns."
