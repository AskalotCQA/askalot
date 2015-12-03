Mooc::Engine.routes.draw do
  post '/lti', to: 'lti#login'

  devise_for :users, class_name: 'Mooc::User', controllers: { sessions: 'shared/sessions', registrations: 'shared/registrations' }, path: '', path_names: { sign_up: :join, sign_in: :login, sign_out: :logout }, module: :devise
end
