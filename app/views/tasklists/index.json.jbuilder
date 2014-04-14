json.array!(@tasklists) do |tasklist|
  json.extract! tasklist, :name
  json.url tasklist_url(tasklist, format: :json)
end