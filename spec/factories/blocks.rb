FactoryBot.define do
  factory :block do
    content { "MyText" }
    type { "" }
    position { 1 }
    page { nil }
  end
end
