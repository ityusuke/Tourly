# frozen_string_literal: true

Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'tours#index'
  get 'map_search',   to: 'spots#map'
  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  post    '/test_login',   to: 'sessions#test_login'
  delete  'logout',  to: 'sessions#destroy'
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :users, only: %i[new create show edit update destroy follow]
  resources :tours, only: %i[index new create show
                            edit update destroy]

  resources :users do
    member do
      get :favorite
    end
  end
  resources :spots, only: %i[show]
  resources :tours do
    resources :likes, only: %i[create destroy]
    resources :favorites, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
    get '/likes/count', to: 'likes#count'
    get '/comments/count', to: 'comments#count'
  end
end
