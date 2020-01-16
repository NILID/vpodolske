FactoryBot.define do
  factory :profile do
    aboutme { 'About user' }
    gender { 'm' }
    avatar_file_name    { 'file.png'}
    avatar_content_type { 'image/png' }
    avatar_file_size    { 1024 }
  end
end
