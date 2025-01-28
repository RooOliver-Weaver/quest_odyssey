Rails.application.routes.draw do
  devise_for :users
  authenticated :user do
    root to: "pages#dashboard", as: :authenticated_root
  end
  root to: "pages#home"
  resources :campaigns

  get "up" => "rails/health#show", as: :rails_health_check

  resources :characters

end
