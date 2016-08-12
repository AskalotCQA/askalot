module Shared::Facebook::Modal
  extend ActiveSupport::Concern

  included do
    after_action :show_facebook_modal
  end

  def show_facebook_modal
    if current_user
      if session[:facebook_modal] == nil && Shared::Configuration.facebook.enabled &&
          Shared::Configuration.facebook.application.id != 'TODO' && Shared::Configuration.facebook.application.secret != 'TODO'
        session[:facebook_modal] = true
      elsif session[:facebook_modal] == true && controller_name != 'units'
        session[:facebook_modal] = false
      end
    end
  end
end
