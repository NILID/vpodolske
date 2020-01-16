# используй подгрузку файла, только если есть валидация
# может как-то исправить

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :photo do
    content { "MyString string" }
    year    { 1982 }
    place
    user

    slide { fixture_file_upload(Rails.root.join('spec/factories/files/ru.png'), 'image/png') } 
  end
end
