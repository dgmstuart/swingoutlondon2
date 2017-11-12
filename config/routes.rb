Swingoutlondon2::Application.routes.draw do
  devise_for :users
  resources :events, only: [:index, :show, :new, :create] do
    resources :dates, only: [:new, :create]
    resources :event_periods, only: [:new, :create, :edit, :update]
  end

  resources :event_instances, only: [:index, :destroy]

  resources :cancellations, only: [:create, :destroy]

  resources :dance_classes, only: [:index, :show, :new, :create]

  resources :venues, only: [:index]

  authenticated :user do
    root 'event_instances#index', as: :authenticated_root
  end

  root to: 'pages#home'

  # test page to show that Main.elm displays
  get '/test', to: 'pages#test'
end
