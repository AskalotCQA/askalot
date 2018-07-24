module Shared::Facebook::Modal
  extend ActiveSupport::Concern

  TOKEN_CHECK_DELAY = 1.day.from_now

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
        
        if session[:facebook_modal] == nil && current_user.send_facebook_notifications && facebook_token_check_expired?
          token_expired = false

          begin
            token_expired = !FbGraph2::Auth.new(Shared::Configuration.facebook.application.id, Shared::Configuration.facebook.application.secret).debug_token!(current_user.omniauth_token).is_valid
          rescue FbGraph2::Exception
            token_expired = false
          end

          if token_expired
            session[:facebook_modal]  = true
            @facebook_modal_restoring = true
          end
        end
      end
    end
  end

  def facebook_token_check_expired?
    token_checked = cookies[:facebook_token_checked]

    return false if token_checked

    cookies[:facebook_token_checked] = {
      value:   1,
      expires: TOKEN_CHECK_DELAY,
    }

    true
  end
end
