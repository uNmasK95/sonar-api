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

end
