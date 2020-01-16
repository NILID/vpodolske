FactoryBot.define do
  factory :bug do
    content { "MyText with more than 10 symbols" }
    url     { "MyText" }
    status  { 1 }
  end
end
