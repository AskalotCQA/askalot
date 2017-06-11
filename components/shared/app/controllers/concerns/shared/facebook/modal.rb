module Shared::Facebook::Modal
  extend ActiveSupport::Concern

  included do
    before_action :show_facebook_modal
  end

  def show_facebook_modal
    if current_user
      if Shared::Configuration.facebook.enabled && Shared::Configuration.facebook.application.id != 'TODO' && Shared::Configuration.facebook.application.secret != 'TODO'
        if current_user.send_facebook_notifications.nil?
          current_user.send_facebook_notifications = false
          current_user.save

          @facebook_modal_joining = true
        end

        if current_user.send_facebook_notifications && !FbGraph2::Auth.new(Shared::Configuration.facebook.application.id, Shared::Configuration.facebook.application.secret).debug_token!(current_user.omniauth_token).is_valid
          current_user.send_facebook_notifications = false
          current_user.save

          @facebook_modal_restoring = true
        end
      end
    end
  end
end
