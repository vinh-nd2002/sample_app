# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Create a main sample user.
User.create!(name:  "Vinh đẹp trai",
  email: "duyvinh@gmail.com",
  password:              "123456",
  password_confirmation: "123456",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)


# Generate a bunch of additional users.

20.times do |n|
  name = Faker::Name.name
  email = "example#{n + 1}@gmail.org"
  password = "123456"
  user = User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
  20.times do
    content = Faker::Lorem.sentence
    user.microposts.create!(content: content)
  end
end
