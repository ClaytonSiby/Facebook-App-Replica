Rails.application.routes.draw do
  root 'users#index'
  devise_for :users

  resources :users, only: %i[index show] do
    resources :friendships, only: %i[create]
  end

  resources :posts, only: %i[index new create show destroy] do
    resources :likes, only: %i[create]
  end

  resources :comments, only: %i[new create destroy] do
    resources :likes, only: %i[create]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end
