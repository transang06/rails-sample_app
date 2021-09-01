# Create a main sample user.
User.create!(name: "Trần Văn Sáng",
    email: "vansang10a6txqt@gmail.com",
    password: "vansang",
    password_confirmation: "vansang",
    admin: true,
    activated: true,
    activated_at: Time.zone.now)
User.create!(name: "Example User",
    email: "example@railstutorial.org",
    password: "foobar",
    password_confirmation: "foobar",
    admin: true,
    activated: true,
    activated_at: Time.zone.now)
  # Generate a bunch of additional users.
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end
