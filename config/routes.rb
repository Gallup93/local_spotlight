Rails.application.routes.draw do
  get '/', to: 'welcome#index'
  namespace :api do
    namespace :v1 do
      get '/login', to: 'auth#spotify_request'
      get '/user', to: 'users#create'
    end
  end 
 
end
