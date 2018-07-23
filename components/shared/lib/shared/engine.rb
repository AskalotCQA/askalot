module Shared
  class Engine < ::Rails::Engine
    isolate_namespace Shared

    config.i18n.load_path += Dir[config.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    config.to_prepare do
      Devise::SessionsController.layout "#{Rails.module}/application"
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths['db/migrate'].concat config.paths['db/migrate'].expanded

        ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths | app.config.paths['db/migrate'].to_a
        ActiveRecord::Migrator.migrations_paths             = ActiveRecord::Migrator.migrations_paths | app.config.paths['db/migrate'].to_a
      end
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
