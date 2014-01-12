class RegistrationsController < Devise::RegistrationsController
  include Tabbing

  default_tab :'user-profile', only: :edit

  def destroy
    fail
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
