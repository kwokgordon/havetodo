json.array!(@tasks) do |task|
  json.extract! task, :name, :note, :due_date, :completed, :completed_date
  json.url task_url(task, format: :json)
end