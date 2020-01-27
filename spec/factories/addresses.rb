FactoryBot.define do
  factory :address do
    address   { 'New York, NY' }
    longitude { Faker::Address.longitude }
    latitude  { Faker::Address.latitude }
  end
end
