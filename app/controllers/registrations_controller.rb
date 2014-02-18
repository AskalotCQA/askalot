class RegistrationsController < Devise::RegistrationsController
  include Tabbing

  default_tab :'user-profile', only: :edit

  def destroy
    fail
  end

  protected

  def after_sign_up_path_for(resource)
    :welcome
  end

  def after_inactive_sign_up_path_for(resource)
    after_sign_up_path_for(resource)
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def update_resource(resource, params)
    resource.ais_login? ? resource.update_without_password(params) : resource.update_with_password(params)
  end
end
