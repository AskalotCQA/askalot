Askalot::Application.routes.draw do
  mount University::Engine => '/', as: 'university' if Rails.module == 'university'
  mount MOOC::Engine => '/', as: 'mooc' if Rails.module == 'mooc'
  mount Shared::Engine => '/', as: 'shared'
end
