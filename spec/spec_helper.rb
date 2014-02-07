# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Capybara
require 'capybara/rspec'
require 'capybara/rails'

# Cancan
require 'cancan/matchers'

Capybara.default_selector = :css

Capybara.javascript_driver = ENV['DRIVER'] ? ENV['DRIVER'].to_sym : :selenium

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.expect_with :rspec do |c|
    c.syntax = :expect # Allow only usage of expect syntax
  end

  # FactoryGirl
  config.include FactoryGirl::Syntax::Methods

  # Include support
  config.include EmailHelper
  config.include FixtureHelper
  config.include HistoryHelper,               type: :feature
  config.include Logging
  config.include PageHelper,                  type: :feature
  config.include RemoteHelper,                type: :feature
  config.include Select2Helper,               type: :feature
  config.include Users::AuthenticationHelper, type: :feature

  config.before(:each) { reset_emails }

  # Specify paths to use DatabaseCleaner for
  DatabaseHelper.clean :models, :features, :requests
end
