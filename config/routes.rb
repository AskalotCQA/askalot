Askalot::Application.routes.draw do
  mount University::Engine => '/', as: 'university'
  mount Shared::Engine => '/', as: 'shared'
end
