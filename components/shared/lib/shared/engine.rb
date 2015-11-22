module Shared
  class Engine < ::Rails::Engine
    isolate_namespace Shared

    config.to_prepare do
      Devise::SessionsController.layout 'shared/application'
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths['db/migrate'].concat config.paths['db/migrate'].expanded

        ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths | app.config.paths['db/migrate'].to_a
        ActiveRecord::Migrator.migrations_paths = ActiveRecord::Migrator.migrations_paths | app.config.paths['db/migrate'].to_a
      end
    end
  end
end
