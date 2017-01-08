RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)

    load Rails.root.join('db/seeds.rb')
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do |example|
    DatabaseCleaner.clean

    load Rails.root.join('db/seeds.rb') if example.metadata[:js]
  end
end
