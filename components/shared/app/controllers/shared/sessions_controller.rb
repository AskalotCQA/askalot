module University
class SessionsController < Devise::SessionsController
  include Devise::Controllers::Rememberable

  def create
    service = Users::Authentication.new Stuba::AIS, login_params

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
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def login_params
    params.require(:user).permit(:login, :password, :remember_me)
  end
end
end
