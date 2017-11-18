Swingoutlondon2::Application.routes.draw do
  devise_for :users
  resources :events, only: %i[index show new create] do
    resources :dates, only: %i[new create]
    resources :event_periods, only: %i[new create edit update]
  end

  resources :event_instances, only: %i[index destroy]

  resources :cancellations, only: %i[create destroy]

  resources :dance_classes, only: %i[index show new create]

  resources :venues, only: [:index]

  authenticated :user do
    root 'event_instances#index', as: :authenticated_root
  end

  root to: 'pages#home'
end
