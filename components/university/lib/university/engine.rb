module University
  class Engine < ::Rails::Engine
    isolate_namespace University

    config.to_prepare do
      Devise::SessionsController.layout "university/application"
    end
  end
end
