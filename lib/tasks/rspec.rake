namespace :rspec do
  desc 'Update user alumni flag'
  task test: :environment do
    sh "bundle exec rspec --pattern=spec/shared/**/*_spec.rb,spec/#{Rails.module}/**/*_spec.rb"
  end
end
