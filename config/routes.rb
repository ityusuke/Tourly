# frozen_string_literal: true

Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'static_pages#home'
  get '/about' => 'static_pages#about'
  get '/search' => 'static_pages#search'
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
  resources :relationships, only: %i[create destroy]

  resources :users do
    member do
      get :followings, :followers, :favorite
    end
  end
  resources :tours do
    resources :likes, only: %i[create destroy]
    resources :favorites, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
    get '/likes/count', to: 'likes#count'
    get '/comments/count', to: 'comments#count'
  end
end
