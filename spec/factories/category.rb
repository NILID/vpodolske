FactoryBot.define do
  factory :category do
    title { Faker::Lorem.unique.sentence }
  end
end
