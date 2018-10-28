Rails.application.routes.draw do

  get 'sessions/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :properties
  
  root 'static_pages#home'
  get 'static_pages/help'
  get 'static_pages/testform'
  get 'static_pages/railstutorial'
 
  get '/search' => 'static_pages#search' 
  get 'properties/:id' => 'properties#show', as: 'property'
  get 'properties' => 'properties#index', as: 'properties'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :properties
  
end
