Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get 'users/new'
  get 'home/index'

  # sign up
  get 'signup' => 'users#new'

  # sign in 
  get 'signin' => 'sessions#new'
  post 'signin' => 'sessions#create'

  # sign out
  delete 'signout' => 'sessions#destroy'

  root 'home#index'

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only:[:new, :create, :edit, :update]
end
