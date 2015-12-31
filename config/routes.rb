Askalot::Application.routes.draw do
  mount Shared::Engine => '/', as: 'shared'
  mount University::Engine => '/', as: 'university' if Rails.module == 'university'
  mount Mooc::Engine => '/', as: 'mooc' if Rails.module == 'mooc'
end
