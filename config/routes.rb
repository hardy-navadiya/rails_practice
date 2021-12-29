Rails.application.routes.draw do
  get 'users/new'
  get 'home/index'

  # sign up
  get 'signup' => 'users#new'

  root 'home#index'

  resources :users
end
