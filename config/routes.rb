Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  get "/about", to: "pages#about"
  get "/services", to: "pages#services"
  get "/contacts", to: "pages#contacts"
  get "/privacy", to: "pages#privacy"

  resources :inquiries, only: :create

  namespace :admin do
    root "sessions#new"
    resource :session, only: [ :new, :create, :destroy ]
    resources :inquiries, only: [ :index, :edit, :update, :destroy ]
  end
end
