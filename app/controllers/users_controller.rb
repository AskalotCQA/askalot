class UsersController < ApplicationController
  include Tabbing

  before_action :authenticate_user!

  default_tab :'users-all', only: :index

  def index
    @users = case params[:tab].to_sym
             when :'users-all'    then User.order(:nick)
             when :'users-recent' then User.recent.order(:created_at)
             else fail
             end

    @users = @users.page(params[:page]).per(60)
  end

  def show
    @user = User.find_by_nick params[:nick]

    raise ActiveRecord::RecordNotFound unless @user
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:notice] = t 'devise.registrations.updated'
    else
      flash_error_messages_for current_user
    end

    redirect_to edit_user_registration_path(tab: params[:tab])
  end

  def suggest
    @users = User.where('nick like ?', "#{params[:q]}%")

    render json: @users, root: false
  end

  private

  def user_params
    attributes = [:email, :nick, :about, :gravatar_email, :show_name, :show_email]

    attributes += Social.networks.keys
    attributes += [:first, :last] if can? :change_name, current_user
    attributes += [:password, :password_confirmation] if can? :change_password, current_user

    params.require(:user).permit(attributes)
  end
end
