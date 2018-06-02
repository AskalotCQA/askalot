require 'simplecov'

SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'fiit_test'

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'cancan/matchers'
require 'selenium/webdriver'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara.default_selector  = :css
Capybara.javascript_driver = ENV['DRIVER'] ? ENV['DRIVER'].to_sym : :headless_chrome
Capybara.server            = :webrick

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Rails.application.routes.default_url_options[:context_uuid] = 'course_uuid' if Rails.module.mooc?

RSpec.configure do |config|
  config.fixture_path                         = "#{::Rails.root}/spec/fixtures"
  config.example_status_persistence_file_path = "#{Rails.root}/spec/specs_with_statuses_#{Rails.module}.txt"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # In order to make example reference yield inside it, before, each blocks
  config.expose_current_running_example_as :example

  # Choose type of spec based on it's directory
  config.infer_spec_type_from_file_location!

  # FactoryGirl
  config.include FactoryGirl::Syntax::Methods

  # Engine routes
  config.include Shared::Engine.routes.url_helpers, type: :feature
  config.include "#{Rails.module.capitalize}::Engine".constantize.routes.url_helpers, type: :feature

  # Include support
  config.include Warden::Test::Helpers, type: :request
  config.include Shared::AuthenticationHelper, type: :feature
  config.include Shared::CapybaraHelpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Shared::EmailHelper
  config.include Shared::FixtureHelper
  config.include Shared::Logging
  config.include Shared::NotificationsHelper
  config.include Shared::PageHelper, type: :feature
  config.include Shared::PollingHelper, type: :feature
  config.include Shared::RemoteHelper, type: :feature
  config.include Shared::TextcompleteHelper, type: :feature

  config.before do
    reset_emails

    [Shared::Category, Shared::Question, Shared::Tag, Shared::User].each { |model| model.autoimport = false }

    Shared::Configuration.poll.default          = 60

    Shared::Context::Manager.current_context_id = Rails.module.university? ? 2 : 1
  end

  config.before(:each, type: :feature, js: true) do
    Capybara.current_session.driver.browser.manage.window.resize_to(1400, 700)
  end
end
