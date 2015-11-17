module Shared
  class Engine < ::Rails::Engine
    isolate_namespace Shared

    config.to_prepare do
      Devise::SessionsController.layout 'shared/application'
    end
  end
end
