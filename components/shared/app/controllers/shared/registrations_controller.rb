module Shared
class RegistrationsController < Devise::RegistrationsController
  include Shared::Applications::Tab

  skip_before_filter :login_required

  default_tab :profile, only: :edit

  def destroy
    fail
  end

  protected

  def after_sign_up_path_for(resource)
    shared.welcome_path
  end

  def after_inactive_sign_up_path_for(resource)
    after_sign_up_path_for(resource)
  end

  def after_update_path_for(resource)
    shared.edit_user_registration_path(tab: :account)
  end

  def update_resource(resource, params)
    service = Shared::Users::Authentication.new Shared::Stuba::AIS, login: current_user.login, password: params[:current_password]

    if service.authorized?
      resource.update_without_password(params.except(:current_password))
    else
      resource.update_with_password(params)
    end
  end
end
end
