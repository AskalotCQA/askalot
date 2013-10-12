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
    path = example.metadata[:file_path]

    if DatabaseHelper.clean_path?(path)
      DatabaseCleaner.strategy = :truncation

      DatabaseCleaner.start
    end
  end

  config.after(:each) do
    path = example.metadata[:file_path]

    DatabaseCleaner.clean if DatabaseHelper.clean_path?(path)
  end
end
