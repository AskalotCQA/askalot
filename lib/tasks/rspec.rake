namespace :rspec do
  desc 'Run tests'
  task test: :environment do
    sh "bundle exec rspec --pattern=spec/shared/**/*_spec.rb,spec/#{Rails.module}/**/*_spec.rb"
  end
end
