require 'shared/stuba/ais'

module Shared
class SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable

  skip_before_filter :login_required

  after_action :allow_inline_frame, only: :new

  def create
    service = Shared::Users::Authentication.new Shared::Stuba::AIS, login_params

    begin
      authorized = service.authorized?
    rescue => e
      authorized = false
      flash[:error] = e.message
    end

    if authorized
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

  private

  def allow_inline_frame
    response.headers['X-Frame-Options'] = 'ALLOWALL'
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Request-Methods'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'X-CSRFToken'
  end
end
end
