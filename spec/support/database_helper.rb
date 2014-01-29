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
  config.before(:all) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    path = example.metadata[:file_path]

    DatabaseCleaner.start if DatabaseHelper.clean_path?(path)
  end

  config.after(:each) do
    path = example.metadata[:file_path]

    DatabaseCleaner.clean if DatabaseHelper.clean_path?(path)
  end
end
