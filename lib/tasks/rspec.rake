namespace :rspec do
  desc 'Run tests'
  task test: :environment do
    sh "bundle exec rspec --pattern=spec/shared/features/*_spec.rb,spec/#{Rails.module}/feature/*_spec.rb"
    end

  desc 'Run failed tests only'
  task test_failed: :environment do
    sh "bundle exec rspec --pattern=spec/shared/**/*_spec.rb,spec/#{Rails.module}/**/*_spec.rb --only-failures"
  end
end
