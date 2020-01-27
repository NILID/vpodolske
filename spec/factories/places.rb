FactoryBot.define do
  factory :place do
    title { "MyString" }
    content { "MyText" }
    address { 'New York, NY' }
    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }

    user
  end
end
