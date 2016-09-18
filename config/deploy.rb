require 'rvm/capistrano'
require 'bundler/capistrano'
require 'whenever/capistrano'
require 'active_support/inflector'

set :stages, [:fiit_staging, :fiit_demo, :fiit_production, :edx_staging, :edx_demo, :edx_production, :lugano_production, :novisad_production]

require 'capistrano/ext/multistage'

set :application,    'askalot'
set :scm,            :git
set :repository,     'git@github.com:isrba/askalot.git'
set :scm_passphrase, ''
set :user,           'deploy'
set(:branch)         { rails_env }
set(:deploy_to)      { "/home/deploy/projects/#{application}-#{rails_env.dasherize}" }
set :linked_dirs,    ['public/attachments']

set :use_sudo, false

set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, 'read-only'       # more info: rvm help autolibs

set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :ssh_options, { forward_agent: true }

# Whenever
set :whenever_command, ->{ "RAILS_ENV=#{rails_env} bundle exec whenever" }
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

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

  desc "Run database seeds"
  task :seed do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:seed"
  end
end

namespace :deploy do
  [:start, :stop, :upgrade].each do |command|
    desc "#{command.to_s.capitalize} unicorn server"
    task command, roles: :app, except: { no_release: true } do
      run "/etc/init.d/unicorn-#{application}-#{rails_env.dasherize} #{command}"
    end
  end

  desc "Restart unicorn server"
  task :restart, roles: :app, except: { no_release: true } do
    run "/etc/init.d/unicorn-#{application}-#{rails_env.dasherize} stop"
    run "sleep 5"
    run "/etc/init.d/unicorn-#{application}-#{rails_env.dasherize} start"
  end

  desc "Symlink shared"
  task :symlink_shared, roles: :app do
    run "ln -nfs #{shared_path} #{release_path}/shared"
    run "for file in #{shared_path}/config/*.yml; do ln -nfs $file #{release_path}/config; done"
  end

  after 'deploy', 'deploy:cleanup'
  after 'deploy:update_code', 'deploy:symlink_shared', 'db:create_release', 'deploy:migrate', 'db:seed'

  after 'deploy:update_code' do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end
