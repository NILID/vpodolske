FactoryBot.define do
  factory :address do
    address   { Faker::Address.street_address }
    longitude { Faker::Address.longitude }
    latitude  { Faker::Address.latitude }
  end
end
