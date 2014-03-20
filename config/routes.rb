Askalot::Application.routes.draw do
  root 'static_pages#home'

  get '/404', to: 'errors#show'
  get '/500', to: 'errors#show'

  devise_for :users, controllers: { sessions: :sessions, registrations: :registrations }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }

  resources :users, only: [:index] do
    patch :profile, on: :collection, to: 'users#update'
    get   :suggest, on: :collection
  end

  get 'users/:nick', to: 'users#show', as: :user

  get :statistics, to: 'statistics#index'
  get :welcome,    to: 'static_pages#welcome'

  resources :changelogs,    only: [:index]
  resources :notifications, only: [:index, :read]
  resources :watchings,     only: [:index, :delete]

  concern :commetable do
    resources :comments, only: [:create, :update]

    get :comment, on: :member
  end

  concern :deletable do
    get :delete, on: :member
  end

  concern :evaluable do
    resources :evaluations, only: [:create, :update]

    get :evaluation, on: :member
  end

  concern :votable do
    get :voteup, on: :member
    get :votedown, on: :member
  end

  resources :categories, only: [:index]

  resources :tags, only: [] do
    get :suggest, on: :collection
  end

  resources :questions, only: [:index, :new, :create, :show, :update] do
    resources :answers, only: [:create, :update]

    get :favor,   on: :member
    get :suggest, on: :collection

    concerns :commetable
    concerns :deletable
    concerns :evaluable
    concerns :votable
  end

  resources :answers, only: [] do
    get :label, on: :member

    concerns :commetable
    concerns :deletable
    concerns :evaluable
    concerns :votable
  end

  resources :comments, only: [] do
    concerns :deletable
  end

  resources :markdown, only: [] do
    post :preview, on: :collection
  end
end
