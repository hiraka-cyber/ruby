Rails.application.routes.draw do
  devise_for :users,controllers:{
    registrations: "users/registrations",
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  get 'auth/:provider/callback', to: 'sessions#create'
  root 'articles#index'

  resources :articles do
    resources :comments
    resources :likes,only: [:create,:destroy]
  end

  resources :users do
    get :search,on: :collection
    member do
      get :following,:followers
    end
  end

  resources :relationships,only: [:create,:destroy]
  resources :messages, only: [:create]
  resources :rooms, only: [:create,:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
