class SessionsController < Devise::SessionsController
  def create
    service = Users::Authentication.new Stuba::Ais, params[:user]

    if service.authorized?
      self.resource = service.authenticate!
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
end
