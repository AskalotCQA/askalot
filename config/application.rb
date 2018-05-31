require File.expand_path('../boot', __FILE__)
require File.expand_path('../version', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "yaml"
# require "rails/test_unit/railtie"

module Rails
  class << self
    def env
      @_env ||= ActiveSupport::StringInquirer.new(ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'fiit_development')
    end

    def env_type
      @_env_type ||= ActiveSupport::StringInquirer.new(env_settings[Rails.env][:type])
    end

    def module
      @_module ||= ActiveSupport::StringInquirer.new(env_settings[Rails.env][:module])
    end

    def env_name
      @_application ||= ActiveSupport::StringInquirer.new(env_settings[Rails.env][:name])
    end

    private

    def env_settings
      @_env_settings ||= HashWithIndifferentAccess.new YAML.load_file(File.expand_path('../environment.yml', __FILE__))
    end
  end
end

# Require the gems listed in Gemfile, including any gems
# e.g. :default, :development, :production, :university, :mooc, :fiit, :edx, :fiit_development, :edx_test
Bundler.require(:default, Rails.env, Rails.env_type, Rails.module, Rails.env_name)

module Askalot
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set error field rendering function.
    config.action_view.field_error_proc = lambda { |html, instance| html }

    # Set exceptions application, allows custom error handling.
    config.exceptions_app               = self.routes

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone                    = 'Bratislava'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.default_locale          = :sk

    config.i18n.load_path += Dir[Rails.root.join 'config', 'locales', '**', '*.{rb,yml}']

    config.i18n.available_locales      = [:en, :sk]

    # Export DB schema in SQL format
    config.active_record.schema_format = :sql

    # Raise standard errors in `after_rollback`/`after_commit` callbacks
    config.active_record.raise_in_transactional_callbacks = true

    config.web_console.development_only = false
  end
end
