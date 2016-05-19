Shared::Engine.routes.draw do
  scope '/' do
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

    authenticated do
      root to: 'static_pages#dashboard', as: :authenticated
    end

    root 'static_pages#home'

    devise_for :users, class_name: 'Shared::User', controllers: { sessions: 'shared/sessions', registrations: 'shared/registrations' }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }, module: :devise

    resources :users, only: [:index] do
      patch :profile,  on: :collection, to: 'users#update'
      get   :suggest,  on: :collection

      get :follow, on: :member
      get :reset_dashboard_time, on: :member

      concerns :searchable
    end

    get 'users/:nick',            to: 'users#show',       as: :user
    get 'users/:nick/activities', to: 'users#activities', as: :user_activities
    get 'users/:nick/followings', to: 'users#followings', as: :user_followings

    get :statistics, to: 'statistics#index'
    get :help,       to: 'static_pages#help'
    get :welcome,    to: 'static_pages#welcome'
    get :welcome2,    to: 'static_pages#welcome_without_confirmation'

    get 'auth/facebook' # path definition so it can be referenced in views ("overriden" by parent application)

    post 'facebook',              to: 'facebook#index'
    post 'facebook/notification', to: 'facebook#notification'

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
      root 'categories#index'

      resources :assignments, only: [:index, :create, :update, :destroy]

      resources :changelogs, only: [:index, :create, :update, :destroy]

      resources :news, only: [:index, :create, :update, :destroy]

      resources :categories, except: [:show] do
        post 'copy'     => 'categories#copy', on: :collection
        post 'settings' => 'categories#update_settings', on: :collection
      end

      get  :emails, to: 'emails#index'
      post :emails, to: 'emails#create'
    end

    resources :changelogs, only: [:index]
    resources :news, only: [:index]
  end
end
