Askalot::Application.routes.draw do
  concern :commetable do
    resources :comments, only: [:create, :update, :destroy]

    get :comment, on: :member
  end

  concern :evaluable do
    resources :evaluations, only: [:create, :update]

    get :evaluation, on: :member
  end

  concern :searchable do
    get :search, on: :collection
  end

  concern :votable do
    get :voteup,   on: :member
    get :votedown, on: :member
  end

  concern :watchable do
    get :watch, on: :member
  end

  root 'static_pages#home'

  get '/404', to: 'errors#show'
  get '/500', to: 'errors#show'

  devise_for :users, controllers: { sessions: :sessions, registrations: :registrations }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }

  resources :users, only: [:index] do
    patch :profile,  on: :collection, to: 'users#update'
    get   :suggest,  on: :collection

    get :follow, on: :member

    concerns :searchable
  end

  get 'users/:nick',            to: 'users#show',       as: :user
  get 'users/:nick/activities', to: 'users#activities', as: :user_activities
  get 'users/:nick/followings', to: 'users#followings', as: :user_followings

  get :statistics, to: 'statistics#index'
  get :help,       to: 'static_pages#help'
  get :welcome,    to: 'static_pages#welcome'

  get 'auth/:provider/callback', to: 'users#facebook'
  get 'auth/failure', to: redirect('/')

  resources :categories do
    concerns :searchable
    concerns :watchable
  end

  resources :tags, only: [:index] do
    get :suggest, on: :collection

    concerns :searchable
    concerns :watchable
  end

  resources :questions, only: [:index, :new, :create, :show, :update, :destroy] do
    resources :answers, only: [:create, :update, :destroy]

    get :favor,   on: :member
    get :suggest, on: :collection

    concerns :commetable
    concerns :evaluable
    concerns :searchable
    concerns :votable
    concerns :watchable
  end

  resources :answers, only: [:update, :destroy] do
    get :label, on: :member

    concerns :commetable
    concerns :evaluable
    concerns :votable
  end

  resources :comments, only: [:update, :destroy]

  resources :markdown, only: [] do
    post :preview, on: :collection
  end

  resources :activities, only: [:index]

  resources :notifications, only: [:index] do
    get :clean, on: :collection

    get :read,   on: :member
    get :unread, on: :member
  end

  resources :watchings, only: [:index, :destroy] do
    delete :clean, on: :collection
  end

  namespace :administration do
    root 'dashboard#index'

    resources :assignments, only: [:create, :update, :destroy]
    resources :categories,  only: [:create, :update, :destroy]
    resources :changelogs,  only: [:create, :update, :destroy]
  end

  resources :changelogs

  post 'facebook/*path', to: 'facebook#redirect', as: :facebook
end
