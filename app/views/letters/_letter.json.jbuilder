json.extract! letter, :id, :content, :email, :created_at, :updated_at
json.url letter_url(letter, format: :json)
