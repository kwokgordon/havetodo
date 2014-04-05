json.set! :sucess, true
json.set! :info, "ok"

json.set! :data do
  json.set! :friends do
    json.array!(@friends) do |task|
      json.extract! friendships, :user_id, :friend_id 
    end
  end
end
