set :domain, '37.205.9.136'

server domain, :app, :web, :db, primary: true

set :deploy_to, "/home/deploy/projects/#{application}-staging"
set :user,      'deploy'
set :rails_env, 'staging'
set :branch,    'staging'

role :db, domain, primary: true

set :rvm_ruby_string, '2.0.0@tp-1314-13'
