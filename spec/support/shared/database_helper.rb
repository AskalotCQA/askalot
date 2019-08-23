RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    load Rails.root.join('db/seeds.rb')
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.append_after(:each) do |example|
    DatabaseCleaner.clean
    load Rails.root.join('db/seeds.rb')
  end
end
