Rails.application.routes.draw do

  get '/', to: 'welcome#index'

  resources :artists, only: [ :show, :new, :create, :index ]
  get '/logout', to: 'sessions#destroy'

  get 'favorites/:id/delete', to: 'favorites#destroy'

  get '/favorites', to: 'favorites#index'
  get 'favorites/:id/new', to: 'favorites#new'

  namespace :api do
    namespace :v1 do
      patch "/users", to: 'users#update'
      get '/login', to: 'auth#spotify_request'
      get '/user', to: 'users#create'
      get '/preferences', to: 'users#update'
      get '/dashboard', to: 'users#show'
    end
  end
end
