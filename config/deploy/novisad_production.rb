set :domain, 'askalot.fiit.stuba.sk'

server domain, :app, :web, :db, primary: true

set :user,      'deploy'
set :rails_env, 'novisad_production'
set :branch,    'master'

role :db, domain, primary: true
