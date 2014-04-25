json.array!(@task_comments) do |task_comment|
  json.extract! task_comment, :task_id, :user_id, :user_name, :comment
  json.url task_comment_url(task_comment, format: :json)
end