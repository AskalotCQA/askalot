Askalot::Application.routes.draw do
  scope = Rails.module.mooc? ? '/(:context)/' : '/'

  scope scope do
    mount Shared::Engine => '/', as: 'shared'
    mount University::Engine => '/', as: 'university' if Rails.module == 'university'
    mount Mooc::Engine => '/', as: 'mooc' if Rails.module == 'mooc'

    root 'static_pages#home'
  end
end
