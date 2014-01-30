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
end
