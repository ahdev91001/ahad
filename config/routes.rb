Rails.application.routes.draw do

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
  resources :users
end
