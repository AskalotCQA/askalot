require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

if ENV['COVERAGE'] == 'true'
  require 'simplecov'

  SimpleCov.start 'rails'
end

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Capybara
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

# Cancan
require 'cancan/matchers'

Capybara.default_selector  = :css
Capybara.javascript_driver = ENV['DRIVER'] ? ENV['DRIVER'].to_sym : :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, window_size: [1600, 1200], inspector: true)
end

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

  # Fail after first fail
  config.fail_fast = false

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

  # In order to make example reference yield inside it, before, each blocks
  config.expose_current_running_example_as :example

  # Choose type of spec based on it's directory
  config.infer_spec_type_from_file_location!

  # FactoryGirl
  config.include FactoryGirl::Syntax::Methods

  # Engine routes
  config.include University::Engine.routes.url_helpers, type: :feature
  config.include Shared::Engine.routes.url_helpers, type: :feature

  # Include support
  config.include AuthenticationHelper, type: :feature
  config.include CapybaraHelpers,      type: :feature
  config.include Devise::TestHelpers,  type: :controller
  config.include EmailHelper
  config.include FixtureHelper
  config.include Logging
  config.include NotificationsHelper
  config.include PageHelper,           type: :feature
  config.include PollingHelper,        type: :feature
  config.include RemoteHelper,         type: :feature
  config.include TextcompleteHelper,   type: :feature

  config.before(:each) { reset_emails }

  config.before(:each) do
    [Shared::Category, Shared::Question, Shared::Tag, Shared::User].each { |model| model.autoimport = false }

    Shared::Configuration.poll.default = 60
  end
end
