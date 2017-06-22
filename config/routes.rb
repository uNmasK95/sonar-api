Rails.application.routes.draw do

  post '/login', to: 'authentication#authenticate'

  namespace :admin do
    resources :users
  end

  resources :lines do
    resources :graphics do
      resources :metrics
    end
  end

  resources :zones do
    resources :sensors do
      # actions with sensors
      get   '/state', to: 'sensors#state'
      post  '/turnOn', to: 'sensors#turnOn'
      post  '/turnOff', to: 'sensors#turnOff'
      post  '/timerate', to: 'sensors#timerate'
    end
  end

  #turnOff
  #turnOn
  #state
  #change rate

  get '/reads', to: 'reads#index'

  # send read by sensor
  post '/reads', to: 'reads#create'

  resources :notifications, only: [ :update, :index ]
  post '/notifications/seeall', to: 'notifications#updateAll'

end
