Askalot::Application.routes.draw do
  mount University::Engine => '/', as: 'university' if Askalot::Application.is? University
  mount Mooc::Engine => '/', as: 'mooc' if Askalot::Application.is? Mooc
  mount Shared::Engine => '/', as: 'shared'
end
