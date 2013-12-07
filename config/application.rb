require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module NaRuby
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Bratislava'


    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.default_locale = :sk

    config.i18n.load_path += Dir[Rails.root.join 'config', 'locales', '**', '*.{rb,yml}']

    # Enforce available locales validation
    config.i18n.enforce_available_locales = true
    # TODO (smolnar) rm in future version of i18n, ref: http://stackoverflow.com/questions/20361428/rails-i18n-validation-deprecation-warning
    I18n.config.enforce_available_locales = true
  end
end
