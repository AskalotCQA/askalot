Askalot::Application.routes.draw do
  mount University::Engine => '/', as: 'university'
end
