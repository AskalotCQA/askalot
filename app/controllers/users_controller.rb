class UsersController < ApplicationController
  before_action :authenticate_user!

  default_tab :all, only: :index
  default_tab :profile, only: :show
  default_tab :followers, only: :followings

  def index
    @users = case params[:tab].to_sym
             when :recent then User.recent.order(created_at: :desc)
             else User.order(:nick)
             end

    @users = @users.page(params[:page]).per(60)
  end

  def show
    @user = User.where(nick: params[:nick]).first || raise(ActiveRecord::RecordNotFound)

    @questions           = @user.questions.where(anonymous: false).order(created_at: :desc)
    @anonymous_questions = @user.questions.where(anonymous: true).order(created_at: :desc)
    @answers             = @user.answers.order(created_at: :desc)
    @favorites           = @user.favorites.order(created_at: :desc)
    @comments            = @user.comments.order(created_at: :desc)
    @activities          = @user.activities.order(created_at: :desc)

    @questions           = @questions.page(tab_page :questions).per(10)
    @anonymous_questions = @anonymous_questions.page(tab_page :anonymous_questions).per(10)
    @answers             = @answers.page(tab_page :answers).per(10)
    @favorites           = @favorites.page(tab_page :favorites).per(10)
    @activities          = @activities.page(tab_page :activities).per(20)

    @question = Question.unanswered.random.first || Question.random.first
  end

  def update
    authorize! :edit, current_user

    if current_user.update_attributes(user_params)
      form_message :notice, t('user.update.success'), key: params[:tab]
    else
      form_error_messages_for current_user, key: params[:tab]
    end

    redirect_to edit_user_registration_path(tab: params[:tab])
  end

  def follow
    @followee = User.find(params[:id])

    authorize! :follow, @followee

    current_user.toggle_following_by! @followee

    params[:profile] ? redirect_to(:back) : render('follow', formats: :js)
  end

  def followings
    @user = User.where(nick: params[:nick]).first || raise(ActiveRecord::RecordNotFound)

    @followees = @user.followees.order(:nick).page(tab_page :followees).per(20)
    @followers = @user.followers.order(:nick).page(tab_page :followers).per(20)
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
