Mooc::Engine.routes.draw do
  post '/lti', to: 'lti#login'

  devise_for :users, class_name: 'Mooc::User', controllers: { sessions: 'shared/sessions', registrations: 'shared/registrations' }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }, module: :devise

  resources :units, only: [:index, :new, :create, :show, :update, :destroy]

  resources :units, only: [:update, :destroy] do
    resources :questions, only: [] do
      get :document_index, on: :collection, as: :index
    end
  end
end
