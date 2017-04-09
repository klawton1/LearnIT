Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'users#home'
  resources :users, only: [:create, :show, :update]
  get '/search/:q', to: 'courses#search', as: 'search'
  get '/courses/:id', to: 'courses#show', as: 'course'

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  
end
