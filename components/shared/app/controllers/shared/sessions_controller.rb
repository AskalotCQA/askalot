require 'shared/stuba/ais'

module Shared
class SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable

  skip_before_filter :login_required

  def create
    service = Shared::Users::Authentication.new Shared::Stuba::AIS, login_params

    if service.authorized?
      self.resource = service.authenticate!

      self.resource.remember_me = login_params[:remember_me]
    else
      self.resource = warden.authenticate!(auth_options)
    end

    create_session
  end

  protected

  def create_session
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if !current_user.dashboard_last_sign_in_at || (current_user.last_sign_in_at > current_user.dashboard_last_sign_in_at)
      current_user.update(dashboard_last_sign_in_at: current_user.last_sign_in_at)
    end
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def login_params
    params.require(:user).permit(:login, :password, :remember_me)
  end
end
end
