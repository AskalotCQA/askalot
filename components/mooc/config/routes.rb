Mooc::Engine.routes.draw do
  post '/units', to: 'units#show'

  devise_for :users, class_name: 'Mooc::User', controllers: { sessions: 'shared/sessions', registrations: 'shared/registrations' }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }, module: :devise

  resources :units, only: [:show]

  resources :units do
    resources :questions, only: [:index, :create, :show, :update, :destroy]
  end
end
