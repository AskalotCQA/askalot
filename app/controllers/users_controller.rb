class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find_by_login params[:login]
  end

  def update_profile
    if current_user.update_attributes(user_params)
      flash[:notice] = t 'devise.registrations.updated'
    else
      flash_error_messages_for current_user, flash: flash
    end

    redirect_to edit_user_registration_path
  end

  private

  def user_params
    attributes = [:nick, :about, :gravatar_email, :facebook, :twitter, :linkedin, :flag_show_name, :flag_show_email]

    attributes += [:first, :last] if can? :change_name, current_user

    params.require(:user).permit(attributes)
  end
end
