module MOOC
  class ApplicationController < ActionController::Base
    protected

    # concerns order is significant
    include Shared::Applications::Security
    include Shared::Applications::Flash
    include Shared::Applications::Form
    include Shared::Applications::Tab

    include Shared::Events::Log

    include Shared::Facebook::Modal
    include Shared::Slido::Flash

    layout 'shared/application'

    def current_ability
      @current_ability ||= Shared::Ability.new(current_user)
    end

    ApplicationController.append_view_path('components/mooc/app/views')
  end
end
