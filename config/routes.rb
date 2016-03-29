Askalot::Application.routes.draw do
  get '/404', to: 'errors#show', as: 'error_404'
  get '/500', to: 'errors#show', as: 'error_500'

  mount Shared::Engine => '/', as: 'shared'
  mount University::Engine => '/', as: 'university' if Rails.module.university?
  mount Mooc::Engine => '/', as: 'mooc' if Rails.module.mooc?

  root 'static_pages#home'
end
