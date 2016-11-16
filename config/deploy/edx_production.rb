set :domain, 'askalot.fiit.stuba.sk'

server domain, :app, :web, :db, primary: true

set :user,      'deploy'
set :rails_env, 'edx_production'
set :branch,    'question-routing-gama-feature'

role :db, domain, primary: true
