Askalot::Application.routes.draw do
  mount Shared::Engine => '/', as: 'shared'
  mount University::Engine => '/', as: 'university'
end
