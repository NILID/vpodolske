require 'faker'

FactoryBot.define do
  factory :video do
    user
    title { Faker::Lorem.word }
    url   { "https://youtu.be/#{Faker::Internet.unique.password(11)}" }
  end
end
