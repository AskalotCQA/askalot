set :domain, 'askalot.fiit.stuba.sk'

server domain, :app, :web, :db, primary: true

set :user,      'deploy'
set :rails_env, 'fiit_staging'
set :branch,    'staging'

role :db, domain, primary: true
