FactoryBot.define do
  factory :note do
    content { Faker::Lorem.paragraph }
  end
end
