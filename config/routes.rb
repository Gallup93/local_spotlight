Rails.application.routes.draw do

  get '/', to: 'welcome#index'

  resources :artists, only: [ :show, :new, :create ]
  get '/logout', to: 'sessions#destroy'

  get '/favorites', to: 'favorites#index'

  namespace :api do
    namespace :v1 do
      get '/login', to: 'auth#spotify_request'
      get '/user', to: 'users#create'
      get '/preferences', to: 'users#update'
      get '/dashboard', to: 'users#show'
    end
  end
end
