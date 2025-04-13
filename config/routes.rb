Rails.application.routes.draw do
  resources :groups do
    member do
      post "join"
      delete "leave"
    end
  end

  get "calendar/index", to: "calendar#index", as: "calendar"

  get "events", to: "events#index", as: "events_index"
  get "events/new", to: "events#new", as: "events_new"
  post "events/create", to: "events#create", as: "events_create"
  get "events/:id/edit", to: "events#edit", as: "events_edit"
  patch "events/:id", to: "events#update", as: "events_update"
  delete "events/:id", to: "events#destroy", as: "events_destroy"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  authenticated :user do
    root to: "home#index", as: :authenticated_root
  end

  root to: redirect("/users/sign_in")

  get "up" => "rails/health#show", as: :rails_health_check
end
