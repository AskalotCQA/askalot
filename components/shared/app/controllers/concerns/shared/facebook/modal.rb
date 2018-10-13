module Shared::Facebook::Modal
  extend ActiveSupport::Concern

  included do
    before_action :show_facebook_modal
  end

  def show_facebook_modal
    if current_user
      if session[:facebook_modal] == nil && Shared::Configuration.facebook.enabled && Shared::Configuration.facebook.application.id != 'TODO' && Shared::Configuration.facebook.application.secret != 'TODO'
        session[:facebook_modal] = true

        if current_user.send_facebook_notifications.nil?
          current_user.send_facebook_notifications = false
          current_user.save

          @facebook_modal_joining = true
        end

        if current_user.send_facebook_notifications
          token_expired = false

          begin
            token_expired = !FbGraph2::Auth.new(Shared::Configuration.facebook.application.id, Shared::Configuration.facebook.application.secret).debug_token!(current_user.omniauth_token).is_valid
          rescue FbGraph2::Exception
            token_expired = true
          end

          if token_expired
            @facebook_modal_restoring = true
          end
        end
      end
    end
  end
end
