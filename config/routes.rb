Askalot::Application.routes.draw do
  scope = Rails.module.mooc? ? '/(:context)/' : '/'

  get '/404', to: 'errors#show', as: 'error_404'
  get '/500', to: 'errors#show', as: 'error_500'

  get 'auth/facebook/callback', to: 'facebook#facebook'

  scope scope do
    get 'auth/facebook', to: redirect('auth/facebook') if Rails.module.mooc?
    get 'auth/failure', to: redirect("#{Rails.application.config.relative_url_root.to_s}/")

    mount Shared::Engine => '/', as: 'shared'
    mount University::Engine => '/', as: 'university' if Rails.module.university?
    mount Mooc::Engine => '/', as: 'mooc' if Rails.module.mooc?
  end
end
