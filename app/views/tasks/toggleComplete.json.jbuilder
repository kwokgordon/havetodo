json.set! :sucess, true
json.set! :info, "ok"

json.set! :data do
  json.extract! @task, :name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id, :created_at, :updated_at
end
