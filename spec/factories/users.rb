require 'faker'

# User roles list
#
# 1  = admin
# 2  = user
# 4  = moderator
# 8  = quest

FactoryBot.define do
  factory :user do
    login { Faker::Lorem.unique.characters(5..9) }
    email { Faker::Internet.unique.email }

    password              { 'password' }
    password_confirmation { 'password' }
    confirmed_at          { Time.now }

    after(:build)  { |u| u.profile = build(:profile) }
    # after(:create) { |u| u.profile.save }

    trait :admin do
      after(:create) { |u| u.update_attribute(:roles_mask, 1) }
    end

    trait :moderator do
      after(:create) { |u| u.update_attribute(:roles_mask, 4) }
    end
  end
end
