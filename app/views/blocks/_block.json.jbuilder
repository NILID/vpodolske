json.extract! block, :id, :content, :type, :position, :page_id, :created_at, :updated_at
json.url block_url(block, format: :json)
