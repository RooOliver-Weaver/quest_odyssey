Rails.application.routes.draw do
  devise_for :users , controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }



  authenticated :user do
    root to: "pages#dashboard", as: :authenticated_root
  end
  root to: "pages#home"

  resources :campaigns do
    resources :campaign_characters, only: [:create] do
      member do
        patch :append_personal_note
      end
    end
    resources :sessions do
      resources :character_sessions, only: [:create, :update, :destroy]
    end
    resources :messages, only: [:create]
    member do
      patch :append_note
      patch :append_dm_note
    end
  end

  patch "/sessions/:id/approve", to: "sessions#approve", as: "session_approval"


  resources :notifications, only: [:index] do
    collection do
      patch :mark_as_read
      delete :delete_read
    end
  end



  get '/calendars', to: 'calendars#index'


  resources :campaign_characters, only: [:update, :destroy]

  resources :characters
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
