Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    get "status" => "status#show"
  end

  get "up" => "rails/health#show", as: :rails_health_check


  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  root to: redirect("/users/sign_in")

  get "dashboard" => "dashboard#index"
end
