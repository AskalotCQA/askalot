set :domain, 'askalot.fiit.stuba.sk'

server domain, :app, :web, :db, primary: true

set :user,      'deploy'
set :rails_env, 'demo'
set :branch,    'demo'

role :db, domain, primary: true
