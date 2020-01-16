json.extract! bug, :id, :content, :buggable_id, :url, :status, :created_at, :updated_at
json.url bug_url(bug, format: :json)
