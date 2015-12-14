set :domain, 'askalot.fiit.stuba.sk'

server domain, :app, :web, :db, primary: true

set :user,      'deploy'
set :rails_env, 'demo_mooc'
set :branch,    'deploy-feature'

role :db, domain, primary: true
