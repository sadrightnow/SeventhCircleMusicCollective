Rails.application.routes.draw do
  # Devise Routes
  devise_for :users

  # Optional: allow sign out via GET (less secure)
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
    get '/users/password', to: 'devise/passwords#new'
  end

  # Users with invite and admin toggle
  resources :users, only: [:index, :destroy] do
    collection do
      post :invite
    end
    member do
      patch :toggle_admin
    end
  end

  # Custom alias for user index
  get 'userist', to: 'users#index', as: 'userist'

  # Custom Past Events Route
  get 'posts/past', to: 'posts#past_events', as: :past_posts

  # Resources
  resources :bands do
    member do
      get :approve
    end
  end

  resources :genres, only: [:index, :new, :create, :destroy]
  resources :posts

  # Google Calendar
  get 'google_calendar_event/:id', to: 'posts#google_calendar_event', as: 'google_calendar_event'
  post 'posts/import_google_calendar', to: 'posts#import_google_calendar', as: :import_google_calendar_posts
  get '/oauth2callback', to: 'oauth#callback'
  get '/authorize_google', to: 'oauth#authorize', as: :authorize_google

  # Static Pages
  get "home/about"
  get "home/contact"
  get "home/contribute"
  get "home/visit"

  # Health Check
  get "up", to: "rails/health#show", as: :rails_health_check

  # PWA
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # Root
  root "posts#index"
end

