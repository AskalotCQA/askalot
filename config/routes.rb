Askalot::Application.routes.draw do
  scope = Rails.module.mooc? ? '/(:context)/' : '/'

  default_url_options :context => Shared::Context::Manager.current_context if Rails.module.mooc?

  get '/404', to: 'errors#show', as: 'error_404'
  get '/500', to: 'errors#show', as: 'error_500'

  scope scope do
    mount Shared::Engine => '/', as: 'shared'
    mount University::Engine => '/', as: 'university' if Rails.module == 'university'
    mount Mooc::Engine => '/', as: 'mooc' if Rails.module == 'mooc'

    root 'static_pages#home'
  end
end
