Askalot::Application.routes.draw do
  scope ENV['RAILS_RELATIVE_URL_ROOT'] || '/' do
    concern :closeable do
      post :close, on: :member
    end

    concern :commetable do
      resources :comments, only: [:create]
    end

    concern :evaluable do
      resources :evaluations, only: [:create]
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

    get 'auth/facebook'
    get 'auth/facebook/callback', to: 'users#facebook'
    get 'auth/failure',           to: redirect('/')

    post 'facebook',              to: 'facebook#index'
    post 'facebook/notification', to: 'facebook#notification'

    resources :groups, only: [:index, :new, :create, :show, :update, :destroy] do
      resources :documents, only: [:create]
    end

    resources :documents, only: [:update, :destroy] do
      resources :questions, only: [] do
        get :document_index, on: :collection, as: :index
      end
    end

    resources :categories, only: [:index] do
      concerns :searchable
      concerns :watchable
    end

    resources :tags, only: [:index] do
      get :suggest, on: :collection

      concerns :searchable
      concerns :watchable
    end

    resources :questions, only: [:index, :new, :create, :show, :update, :destroy] do
      resources :answers, only: [:create]

      get :favor,   on: :member
      get :suggest, on: :collection

      concerns :closeable
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

    resources :evaluations, only: [:update]

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

    resources :changelogs, only: [:index]
  end
end
