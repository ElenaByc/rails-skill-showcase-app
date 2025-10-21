# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
# Destroy certificates first (this clears certificate_skills automatically)
Certificate.destroy_all
# Then destroy the main entities
User.destroy_all
Skill.destroy_all
Issuer.destroy_all

# Create sample users
user1 = User.create!(
  name: "John Doe",
  email: "john@example.com",
  password: "password123"
)

user2 = User.create!(
  name: "Jane Smith", 
  email: "jane@example.com",
  password: "password123"
)

# Create sample skills - EACH USER CREATES THEIR OWN SKILLS
# User1's skills
skill1 = Skill.create!(
  name: "Ruby on Rails",
  description: "Web application framework written in Ruby",
  created_by: user1.id
)

skill2 = Skill.create!(
  name: "JavaScript",
  description: "Programming language for web development",
  created_by: user1.id
)

skill3 = Skill.create!(
  name: "SQL",
  description: "Structured Query Language for database management",
  created_by: user1.id
)

# User2's skills
skill4 = Skill.create!(
  name: "React",
  description: "JavaScript library for building user interfaces",
  created_by: user2.id
)

skill5 = Skill.create!(
  name: "Node.js",
  description: "JavaScript runtime for server-side development",
  created_by: user2.id
)

skill6 = Skill.create!(
  name: "MongoDB",
  description: "NoSQL database program",
  created_by: user2.id
)

# Create sample issuers - EACH USER CREATES THEIR OWN ISSUERS
# User1's issuers
issuer1 = Issuer.create!(
  name: "Codecademy",
  website_url: "https://codecademy.com",
  logo_url: "https://codecademy.com/logo.png",
  description: "Interactive online coding platform",
  created_by: user1.id
)

issuer2 = Issuer.create!(
  name: "FreeCodeCamp",
  website_url: "https://freecodecamp.org",
  logo_url: "https://freecodecamp.org/logo.png",
  description: "Learn to code for free",
  created_by: user1.id
)

# User2's issuers
issuer3 = Issuer.create!(
  name: "Coursera",
  website_url: "https://coursera.org",
  logo_url: "https://coursera.org/logo.png", 
  description: "Online learning platform with courses from top universities",
  created_by: user2.id
)

issuer4 = Issuer.create!(
  name: "Udemy",
  website_url: "https://udemy.com",
  logo_url: "https://udemy.com/logo.png",
  description: "Online learning marketplace",
  created_by: user2.id
)

# Create sample certificates - USERS CAN ONLY USE THEIR OWN SKILLS AND ISSUERS
# User1's certificates
cert1 = Certificate.create!(
  name: "Ruby on Rails Developer Certificate",
  issued_on: Date.parse("2024-01-15"),
  verification_url: "https://codecademy.com/certificates/abc123",
  user: user1,
  issuer: issuer1  # user1's issuer
)

cert2 = Certificate.create!(
  name: "JavaScript Fundamentals",
  issued_on: Date.parse("2024-02-20"),
  verification_url: "https://codecademy.com/certificates/def456",
  user: user1,
  issuer: issuer2  # user1's issuer
)

# User2's certificates
cert3 = Certificate.create!(
  name: "React Development Course",
  issued_on: Date.parse("2024-03-10"),
  verification_url: "https://coursera.org/certificates/ghi789",
  user: user2,
  issuer: issuer3  # user2's issuer
)

cert4 = Certificate.create!(
  name: "Full Stack JavaScript",
  issued_on: Date.parse("2024-04-05"),
  verification_url: "https://udemy.com/certificates/jkl012",
  user: user2,
  issuer: issuer4  # user2's issuer
)

# Associate skills with certificates - ONLY USE SKILLS CREATED BY THE SAME USER
cert1.skills << [skill1, skill3]  # user1's certificate uses user1's skills (Rails + SQL)
cert2.skills << [skill2, skill3]  # user1's certificate uses user1's skills (JS + SQL)
cert3.skills << [skill4, skill6]  # user2's certificate uses user2's skills (React + MongoDB)
cert4.skills << [skill4, skill5, skill6]  # user2's certificate uses user2's skills (React + Node + MongoDB)

puts "Sample data created successfully!"
puts "Users: #{User.count}"
puts "Skills: #{Skill.count}"
puts "Issuers: #{Issuer.count}"
puts "Certificates: #{Certificate.count}"