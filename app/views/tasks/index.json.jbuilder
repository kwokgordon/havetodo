json.set! :sucess, true
json.set! :info, "ok"

json.set! :data do
  json.set! :overdue do
    json.array!(@overdue_tasks) do |task|
      json.extract! task, :id, :name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id 
    end
  end

  json.set! :today do
    json.array!(@today_tasks) do |task|
      json.extract! task, :id, :name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id 
    end
  end

  json.set! :tomorrow do
    json.array!(@tomorrow_tasks) do |task|
      json.extract! task, :id, :name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id 
    end
  end

  json.set! :this_week do
    json.array!(@this_week_tasks) do |task|
      json.extract! task, :id, :name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id 
    end
  end

  json.set! :future do
    json.array!(@future_tasks) do |task|
      json.extract! task, :id, :name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id 
    end
  end

  json.set! :no_duedate do
    json.array!(@no_duedate_tasks) do |task|
      json.extract! task, :id, :name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id 
    end
  end

  json.set! :completed do
    json.array!(@completed_tasks) do |task|
      json.extract! task, :id, :name, :note, :due_date, :due_time, :completed, :completed_date, :completed_user_id 
    end
  end
end