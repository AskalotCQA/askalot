Mooc::Engine.routes.draw do
  scope '/(:context)/' do
  post '/units', to: 'units#show'
  get '/units/error', to: 'units#error'

  devise_for :users, class_name: 'Mooc::User', controllers: { sessions: 'shared/sessions', registrations: 'shared/registrations' }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }, module: :devise

  resources :units, only: [:show] do
    resources :questions, only: [:index, :create, :show, :update, :destroy]
  end

  match '/parser' => "parser#parser", via: [:post]
  match '/parser' => "parser#options", via: [:options]

  namespace :teacher_administration do
    root 'categories#index'

    resources :categories, except: [:show, :destroy] do
      post 'settings' => 'categories#update_settings', on: :collection
    end
  end
  end
end
