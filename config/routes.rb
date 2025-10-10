Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # User dashboard route (place where user can manage their certificates, skills, and issuers)
  get "/users/:id/dashboard", to: "users#dashboard", as: :user_dashboard
  get "/users/:id/showcase", to: "users#showcase", as: :user_showcase
  get "/users/:id/skills", to: "skills#user_index", as: :user_skills
  get "/users/:id/issuers", to: "issuers#user_index", as: :user_issuers

  resources :certificates
  resources :skills
  resources :issuers

  # Defines the root path route ("/")
  # root "posts#index"
end
