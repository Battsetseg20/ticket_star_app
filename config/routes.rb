Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:create]

  # Other routes for additional resources and actions

  root to: 'welcome#index'
end
