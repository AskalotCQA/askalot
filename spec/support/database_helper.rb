module DatabaseHelper
  def self.paths
    @paths ||= []
  end

  def self.clean(*paths)
    @paths = *paths
  end

  def self.clean_path?(path)
    path = File.expand_path(path)

    paths.each do |p|
      return true if path.to_s =~ /spec\/#{p}/
    end

    false
  end
end

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    load Rails.root.join('db/seeds.rb')

    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
