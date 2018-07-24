Askalot::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Uncomment if you are going to play with rails_panel
  # logfile = File.open( 'log/development.log', 'a' )
  # logfile.sync = true
  # config.logger = Logger.new(logfile)

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Default url options for ActionMailer
  config.action_mailer.default_url_options = { host: 'http://localhost', port: 3000, script_name: '/askalot'}
  config.action_mailer.delivery_method = :letter_opener

  # Precompilation for I18n-js
  config.assets.initialize_on_precompile = true

  # Comment if you are going to play with rails_panel
  config.relative_url_root = '/askalot'

  config.web_console.development_only = false

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.add_footer = true
  end
end
