Rails.application.routes.draw do

  post '/login', to: 'authentication#authenticate'

  namespace :admin do
    resources :users
  end

  resources :lines do
    resources :graphics do
      resources :metrics , :only => [:create, :update, :destroy]
    end
  end

  resources :zones do
    resources :sensors do
      # actions with sensors
      post  '/state', to: 'sensors#change' # ver como fazer esta modificação por causa do update
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


end
