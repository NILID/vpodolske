FactoryBot.define do
  factory :organization do
    title { Faker::Team.name }
    url   { Faker::Internet.unique.url }
    site  { Faker::Internet.url }
    email { Faker::Internet.email }

    desc    { 'MyText' }
    address { 'MyText' }
    longitude { 1.5 }
    latitude  { 1.5 }

    worktime { 'worktime' }
    phone { "#{Faker::PhoneNumber.cell_phone} #{Faker::PhoneNumber.cell_phone}" }
    user

    categories { [build(:category), build(:category)] }

    before(:create) do |o|
      o.addresses = [create(:address), create(:address)]
    end

    trait(:hidden)  { status_mask { 1 } }
    trait(:shown)   { status_mask { 2 } }
    trait(:blocked) { status_mask { 4 } }

  end
end
