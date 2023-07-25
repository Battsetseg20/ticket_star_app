# frozen_string_literal: true

Rails.application.routes.draw do
  # Devise routes for User
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  devise_scope :user do
    get "/register/customer", to: "users/registrations#new_customer", as: :new_customer_registration
    get "/register/event_organizer", to: "users/registrations#new_event_organizer",
                                     as: :new_event_organizer_registration
    post "/register/customer", to: "users/registrations#create", defaults: { user_type: "customer" }
    post "/register/event_organizer", to: "users/registrations#create", defaults: { user_type: "event_organizer" }
  end

  resources :event_items, only: [:new, :create, :edit, :update, :show, :index, :destroy]
  resources :purchases, only: [:show] do
    collection do
      get 'buy_tickets', to: 'purchases#create'
      get 'success'
      get 'cancel'
    end
  end
  post '/stripe_webhooks', to: 'stripe_webhooks#receive'
  # TODO:

  # add route for customer dashboard
  # add route for event organizer dashboard

  root to: "welcome#index"
end
