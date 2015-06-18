Swingoutlondon2::Application.routes.draw do
  devise_for :users
  resources :events, only: [:index, :show, :new, :create] do
    resources :dates, only: [:new, :create]
  end

  resources :event_instances, only: [:index, :destroy]

  resources :event_generators, only: [:edit, :update]

  resources :cancellations, only: :update

  resources :dance_classes, only: [:index, :show, :new, :create]

  resources :venues, only: [ :index ]

  root to: "event_instances#index"
end
