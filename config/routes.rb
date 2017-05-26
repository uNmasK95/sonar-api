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
      post  '/state', to: 'simulator#change'
      get   '/state', to: 'simulator#state'
      post  '/timerate', to: 'simulator#timerate'
    end
  end

  get '/reads', to: 'reads#index'

  # send read by sensor
  post '/reads', to: 'reads#create'



end
