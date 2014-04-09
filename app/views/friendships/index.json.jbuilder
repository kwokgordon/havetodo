json.set! :sucess, true
json.set! :info, "ok"

json.set! :data do
  json.set! :friend_request do
    json.array!(@inverse_friendships_request) do |friendship|
      if friendship.user.id == current_user.id
        json.friend_id friendship.friend.id
        json.name friendship.friend.name
      else
        json.friend_id friendship.user.id
        json.name friendship.user.name
      end
    end
  end

  json.set! :your_request do
    json.array!(@friendships_request) do |friendship|
      if friendship.user.id == current_user.id
        json.friend_id friendship.friend.id
        json.name friendship.friend.name
      else
        json.friend_id friendship.user.id
        json.name friendship.user.name
      end
    end
  end

  json.set! :your_friend do
    json.array!(@all_friends) do |friendship|
      if friendship.user.id == current_user.id
        json.friend_id friendship.friend.id
        json.name friendship.friend.name
      else
        json.friend_id friendship.user.id
        json.name friendship.user.name
      end
    end
  end
end
