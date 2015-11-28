Askalot::Application.routes.draw do
  mount University::Engine => '/', as: 'university' if Askalot::Application.config.module == 'University'
  mount MOOC::Engine => '/', as: 'mooc' if Askalot::Application.config.module == 'MOOC'
  mount Shared::Engine => '/', as: 'shared'
end
