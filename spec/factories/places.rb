FactoryBot.define do
  factory :place do
    title { "MyString" }
    content { "MyText" }
    address { Faker::Address.street_address }
    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }

    user
  end
end
