# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "welcome#index"
  get "/disclaimer", to: "welcome#disclaimer", as: :disclaimer
 
  # Devise routes for User
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  # Custom registration routes for User (customer and event organizer)
  devise_scope :user do
    get "/register/customer", to: "users/registrations#new_customer", as: :new_customer_registration
    get "/register/event_organizer", to: "users/registrations#new_event_organizer",
                                     as: :new_event_organizer_registration
    post "/register/customer", to: "users/registrations#create", defaults: { user_type: "customer" }
    post "/register/event_organizer", to: "users/registrations#create", defaults: { user_type: "event_organizer" }
  end

  resources :event_items, only: [:new, :create, :edit, :update, :show, :index, :destroy] do
    collection do
      get 'by_type/:event_type', action: :by_type, as: 'by_type'
      get 'hot_events', action: :hot_events, as: 'hot_events'
    end
    # TODO: will only add later if enough time to implement some kind of reviewer update job that
    # updated the review score of the event item once new reviews are added or old reviews are deleted
    # resources :reviews, only: [:create, :destroy]
  end
  
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
end
