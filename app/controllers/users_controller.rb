class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find_by_login params[:login]
  end

  def update_profile
    if current_user.update_attributes(user_params)
      flash[:notice] = t('devise.registrations.updated')
    else
      flash_error_messages(current_user)
    end

    redirect_to edit_user_registration_path
  end

  private

  def user_params
    params.require(:user).permit(:nick, :first, :last, :about, :facebook, :twitter, :linkedin, :gravatar_email)
  end
end
