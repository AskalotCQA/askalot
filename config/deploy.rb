require 'rvm/capistrano'
require 'bundler/capistrano'
# require 'whenever/capistrano'

set :stages, [:staging, :production]

require 'capistrano/ext/multistage'

set :application,    'naruby'
set :scm,            :git
set :repository,     'git@github.com:pavolzbell/tp-1314-13.git'
set :scm_passphrase, ''
set :user,           'deploy'
set :branch,         rails_env

set :use_sudo, false

set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :ssh_options, { forward_agent: true }

# Whenever
# TODO (smolnar) enable whenever when needed
# set :whenever_command, "RAILS_ENV=#{rails_env} bundle exec whenever"

default_run_options[:pty] = true

namespace :fixtures do
  desc "Creates fixtures data"
  task :all, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake fixtures:all"
  end
end

namespace :db do
  desc "Creates DB"
  task :create, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:create"
  end

  desc "Sets up current DB for this environment"
  task :setup, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:setup"
  end

  desc "Drops DB for this environment"
  task :drop, roles: :db do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake db:drop"
  end

  desc "Migrates DB during release"
  task :create_release, roles: :db do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:create"
  end

  desc "Sets up DB during deployment of release for this environment"
  task :setup_release, roles: :db do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:setup"
  end
end

# If you are using Passenger mod_rails uncomment this
namespace :deploy do
  task :start do
  end

  task :stop do
  end

  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  desc "Symlink shared"
  task :symlink_shared, roles: :app do
    run "ln -nfs #{shared_path} #{release_path}/shared"
    run "for file in #{shared_path}/config/*.yml; do ln -nfs $file #{release_path}/config; done"
  end

  after 'deploy', 'deploy:cleanup'
  after 'deploy:update_code', 'deploy:symlink_shared', 'db:create_release', 'deploy:migrate'

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end
