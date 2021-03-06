HaveTodo::Application.routes.draw do
  root "welcome#index"
  
  get "blank" => "welcome#blank"

  get "stayawake" => "stayawake#index"

  devise_for :users, :controllers => { :registrations => :registrations, :sessions => :sessions }

  # Web access
  devise_scope :user do
    get 'registrations' => 'registrations#new'
    post 'registrations' => 'registrations#create'

    get '/users/sign_up' => 'registration#new'
    post '/users' => 'registration#create'
    get '/users/edit' => 'registration#edit'
    get '/users/cancel' => 'registration#cancel'
#    get '/users/update' => 'registration#update'
#    delete '/users' => 'regrs'

    get '/users/sign_in' => 'sessions#new'
    post '/users/sign_in' => 'sessions#create'
    delete '/users/sign_out' => 'sessions#destroy'
    
    get '/users' => 'users#show'
    
  end

#  resources :users do
#    resources :tasks
#  end

  resources :tasks, path: '/users/tasks' do
    resources :task_comments
    
    post '/toggleComplete' => 'tasks#toggleComplete'
    post '/addFriend/:user_id' => 'tasks#addFriend', as: 'addFriend'
    post '/removeFriend/:user_id' => 'tasks#removeFriend', as: 'removeFriend'
  end
  
  resources :tasklists, path: '/users/tasklists' do
    resources :tasks do
    end

    post '/addFriend/:user_id' => 'tasklists#addFriend', as: 'addFriend'
    post '/removeFriend/:user_id' => 'tasklists#removeFriend', as: 'removeFriend'

  end
  
  resources :friendships, path: '/users/friendships' do
    post '/acceptFriend' => 'friendships#acceptFriend'
    post '/rejectFriend' => 'friendships#rejectFriend'
#    delete '/removeFriend' => 'friendships#removeFriend'
  end

  # Moblie access
  namespace :api do
    devise_scope :user do
      post 'registrations' => 'registrations#create', :as => 'register'
      post 'sessions' => 'sessions#create', :as => 'login'
      delete 'sessions' => 'sessions#destroy', :as => 'logout'
    end
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
