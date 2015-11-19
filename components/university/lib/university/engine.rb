module University
  class Engine < ::Rails::Engine
    isolate_namespace University

    config.to_prepare do
      helpers = Shared.constants.select {|c| c.to_s.ends_with? 'Helper' }
      helpers.each do |helper|
        ApplicationController.helper ('Shared::' + helper.to_s).constantize
      end
    end
  end
end
