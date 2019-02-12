Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do 

    post "/signup" => 'users#create'
    post "/login" => 'sessions#create'
    delete "/logout" => 'sessions#destroy'
    get "/handshake" => 'sessions#csrf_token'
    get '/authenticate' => 'sessions#authenticate'

    resources :users, only: [:index, :show, :create, :update, :destroy] 

    resources :users do 
      resources :games, only: [:index, :create, :update]
    end

    get "/users/:user_id/games/:type/:id" => 'games#show'
    get "/users/:user_id/games/:type" => 'games#index'

    post "/username-check" => 'users#username_check'


  end

end
