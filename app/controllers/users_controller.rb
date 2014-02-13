class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by_nick params[:nick]
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:notice] = t 'devise.registrations.updated'
    else
      flash_error_messages_for current_user
    end

    redirect_to edit_user_registration_path(tab: params[:tab])
  end

  private

  def user_params
    attributes = [:nick, :about, :gravatar_email, :show_name, :show_email]

    attributes += Social.networks.keys
    attributes += [:first, :last] if can? :change_name, current_user

    params.require(:user).permit(attributes)
  end
end
