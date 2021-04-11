# frozen_string_literal: true
random = Random.new

30.times do |n|
  Faker::Config.locale = :ja
  @username = Faker::Name.name
  @email = "ed#{random.rand(1000)}lmdawdl2-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(username: @username,
              email: @email,
              password: password,
              password_confirmation: password)
end

users = User.order(:created_at).take(20)
Faker::Config.locale = :ja
8.times do
  @tourname = Faker::Lorem.sentence
  @tourcontent = Faker::Lorem.sentence
  users.each do |user|
    user.tours.create!(tourname: @tourname,
                      tourcontent: @tourcontent)
  end
end

