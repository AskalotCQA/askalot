class RegistrationsController < Devise::RegistrationsController
  before_filter :set_default_tab, only: :edit

  def destroy
    fail
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  private

  def set_default_tab
    params[:tab] ||= 'user-profile'
  end
end
