Askalot::Application.routes.draw do
  root 'static_pages#home'

  get '/404', to: 'errors#show'
  get '/500', to: 'errors#show'

  devise_for :users, controllers: { sessions: :sessions, registrations: :registrations }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }

  resources :users, only: [:index] do
    patch :profile,  on: :collection, to: 'users#update'
    get   :suggest,  on: :collection

    get :follow, on: :member
  end

  get 'users/:nick',            to: 'users#show',       as: :user
  get 'users/:nick/activities', to: 'users#activities', as: :user_activities
  get 'users/:nick/followings', to: 'users#followings', as: :user_followings


  get :statistics, to: 'statistics#index'
  get :help,       to: 'static_pages#help'
  get :welcome,    to: 'static_pages#welcome'


  concern :commetable do
    resources :comments, only: [:create, :update, :destroy]

    get :comment, on: :member
  end

  concern :evaluable do
    resources :evaluations, only: [:create, :update]

    get :evaluation, on: :member
  end

  concern :votable do
    get :voteup, on: :member
    get :votedown, on: :member
  end

  concern :watchable do
    get :watch, on: :member
  end

  resources :categories, only: [:index, :new, :create, :update] do
    concerns :watchable
  end

  resources :tags, only: [:index] do
    get :suggest, on: :collection

    concerns :watchable
  end

  resources :questions, only: [:index, :new, :create, :show, :update, :destroy] do
    resources :answers, only: [:create, :update, :destroy]

    get :favor,   on: :member
    get :suggest, on: :collection

    concerns :commetable
    concerns :evaluable
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

  resources :changelogs, only: [:index, :new, :create]

  resources :markdown, only: [] do
    post :preview, on: :collection
  end

  resources :notifications, only: [:index] do
    get :clean, on: :collection

    get :read,   on: :member
    get :unread, on: :member
  end

  resources :watchings, only: [:index, :destroy] do
    delete :clean, on: :collection
  end

  namespace "admin" do
    root :to => 'admin#index'
    resources :changelogs, only: [:new, :create]
    resources :categories, only: [:new, :create, :update]
    resources :dashboard,  only: [:index]
  end
end
