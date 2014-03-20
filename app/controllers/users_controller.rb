class UsersController < ApplicationController
  include Tabbing

  before_action :authenticate_user!

  default_tab :all, only: :index
  default_tab :questions, only: :show

  def index
    @users = case params[:tab].to_sym
             when :all    then User.order(:nick)
             when :recent then User.recent.order(:created_at)
             else fail
             end

    @users = @users.page(params[:page]).per(60)
  end

  def show
    @user = User.where(nick: params[:nick]).first

    raise ActiveRecord::RecordNotFound unless @user

    @questions = @user.questions.where(anonymous: false).order(created_at: :desc)
    @answers   = @user.answers.order(created_at: :desc)
    @favorites = Question.favored_by(@user).order(created_at: :desc)

    @questions = @questions.page(tab_page :questions).per(10)
    @answers   = @answers.page(tab_page :answers).per(10)
    @favorites = @favorites.page(tab_page :favorites).per(10)
  end

  def update
    if current_user.update_attributes(user_params)
      form_message :notice, t('user.update.success'), key: params[:tab]
    else
      form_error_messages_for current_user, key: params[:tab]
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
