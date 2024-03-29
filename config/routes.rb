Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'bowling_games', to: 'bowling_games#create'
  put 'bowling_games/:id', to: 'bowling_games#update'
  get 'bowling_games/:id', to: 'bowling_games#show'
end
