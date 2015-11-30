Mooc::Engine.routes.draw do
  post '/lti', to: 'lti#login'
end
