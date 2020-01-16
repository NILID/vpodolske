FactoryBot.define do
  factory :article do
    title    { Faker::Team.name }
    desc     { "MyText" }
    provider { Article::PROVIDERS.sample(1) }

    sequence(:url) { |n| "http://google.com/site#{n}" }
  end
end
