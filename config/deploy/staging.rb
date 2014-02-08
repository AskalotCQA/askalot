set :domain, '37.205.9.136'

server domain, :app, :web, :db, primary: true

set :user,      'deploy'
set :rails_env, 'staging'
set :branch,    'staging'
set :deploy_to, "/home/deploy/projects/#{application}-#{rails_env}"

role :db, domain, primary: true
