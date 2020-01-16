json.array!(@events) do |event|
  json.extract! event, :latitude, :longitude, :address, :title
  json.url user_url(event, format: :json)
end