FactoryBot.define do
  factory :comment do
    association :commentable, factory: [:organization, :shown]
    user

    content { "MyText" }
    state   { 1 }
    # ancestry { "MyString" }

    trait(:shown) { hidden { false } }
  end
end
