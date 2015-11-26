module MOOC
  class Engine < ::Rails::Engine
    isolate_namespace MOOC

    config.to_prepare do
      helpers = Shared.constants.select { |c| c.to_s.ends_with? 'Helper' }

      helpers.each do |helper|
        ApplicationController.helper ('MOOC::' + helper.to_s).constantize
      end
    end if Askalot::Application.is? MOOC

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths['db/migrate'].concat config.paths['db/migrate'].expanded

        ActiveRecord::Tasks::DatabaseTasks.migrations_paths = ActiveRecord::Tasks::DatabaseTasks.migrations_paths | app.config.paths['db/migrate'].to_a
        ActiveRecord::Migrator.migrations_paths = ActiveRecord::Migrator.migrations_paths | app.config.paths['db/migrate'].to_a

        app.config.paths['db'] = config.paths['db'].expanded
        ActiveRecord::Tasks::DatabaseTasks.db_dir = app.config.paths['db'].first
      end
    end if Askalot::Application.is? MOOC
  end
end
