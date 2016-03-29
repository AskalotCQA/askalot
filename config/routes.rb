Askalot::Application.routes.draw do
  get '/404', to: 'errors#show', as: 'error_404'
  get '/500', to: 'errors#show', as: 'error_500'
end
