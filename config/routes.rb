Askalot::Application.routes.draw do
  mount University::Engine => '/university', as: 'university'
end
