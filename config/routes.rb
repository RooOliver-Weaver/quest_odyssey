Rails.application.routes.draw do
  get 'calendars/show'
  devise_for :users , controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  authenticated :user do
    root to: "pages#dashboard", as: :authenticated_root
  end

  root to: "pages#home"
  resources :campaigns do
    resources :campaign_characters, only: [:create]
    resources :sessions do
      resources :character_session, only: [:create, :update, :destory]
    end
    resources :messages, only: [:create]
  end


  get '/calendars', to: 'calendars#index'


  resources :campaign_characters, only: [:update, :destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :characters
end
