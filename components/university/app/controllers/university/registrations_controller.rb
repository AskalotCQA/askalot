module University
class RegistrationsController < Devise::RegistrationsController
  include University::Applications::Tab

  default_tab :profile, only: :edit

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
    edit_user_registration_path(tab: :account)
  end

  def update_resource(resource, params)
    service = University::Users::Authentication.new University::Stuba::AIS, login: current_user.login, password: params[:current_password]

    if service.authorized?
      resource.update_without_password(params.except(:current_password))
    else
      resource.update_with_password(params)
    end
  end
end
end
