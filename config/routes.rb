Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Current user routes
  get "/dashboard", to: "users#dashboard", as: :dashboard
  get "/users/:id/showcase", to: "users#showcase", as: :user_showcase

  # Skills routes
  get "/skills", to: "skills#index", as: :skills
  get "/skills/new", to: "skills#new", as: :new_skill
  get "/skills/:id", to: "skills#show", as: :skill
  post "/skills", to: "skills#create"
  get "/skills/:id/edit", to: "skills#edit", as: :edit_skill
  patch "/skills/:id", to: "skills#update"
  put "/skills/:id", to: "skills#update"
  delete "/skills/:id", to: "skills#destroy", as: :delete_skill

  # Issuers routes
  get "/issuers", to: "issuers#index", as: :issuers
  get "/issuers/new", to: "issuers#new", as: :new_issuer
  get "/issuers/:id", to: "issuers#show", as: :issuer
  post "/issuers", to: "issuers#create"
  get "/issuers/:id/edit", to: "issuers#edit", as: :edit_issuer
  patch "/issuers/:id", to: "issuers#update"
  put "/issuers/:id", to: "issuers#update"
  delete "/issuers/:id", to: "issuers#destroy", as: :delete_issuer

  # Certificate routes
  get "/certificates/new", to: "certificates#new", as: :new_certificate
  get "/certificates/:id", to: "certificates#show", as: :certificate
  post "/certificates", to: "certificates#create"
  get "/certificates/:id/edit", to: "certificates#edit", as: :edit_certificate
  patch "/certificates/:id", to: "certificates#update"
  put "/certificates/:id", to: "certificates#update"
  delete "/certificates/:id", to: "certificates#destroy", as: :delete_certificate

  # Authentication routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "register", to: "users#new"
  post "register", to: "users#create"

  # Defines the root path route ("/")
  root "pages#home"
end
