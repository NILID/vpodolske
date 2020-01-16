FactoryBot.define do
  factory :event do
    title   { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    sequence(:siteurl) { |n| "http://google.com/site#{n}" }

    src_file_name    { 'file.png'}
    src_content_type { 'image/png' }
    src_file_size    { 1024 }

    user

    # ===  default
    #
    # hidden: true

    trait(:shown)    { hidden { false } }
    trait(:today)    { eventdate { (DateTime.now) } }
    trait(:tomorrow) { eventdate { (DateTime.now + 1.day) } }
    trait(:soon)     { eventdate { (DateTime.now + 1.month) } }
  end
end
