module Shared
class UsersController < ApplicationController
  include Events::Dispatch
  include Searchables::Search

  default_tab :all, only: :index
  default_tab :results, only: :search
  default_tab :profile, only: :show
  default_tab :followers, only: :followings

  before_action :authenticate_user!

  def index
    @users = case params[:tab].to_sym
             when :recent then Shared::User.in_context(@context).recent.order(created_at: :desc)
             when :alumni then Shared::User.in_context(@context).alumni.order(:nick)
             else Shared::User.in_context(@context).order(:nick)
             end

    @users = @users.page(params[:page]).per(60)
  end

  def show
    @user = Shared::User.by(nick: params[:nick])

    @questions  = Shared::Question.in_context(@context).by(@user).where(anonymous: false).order(created_at: :desc)
    @anonymous  = Shared::Question.in_context(@context).by(@user).where(anonymous: true).order(created_at: :desc)
    @answers    = Shared::Answer.in_context(@context).by(@user).order(created_at: :desc)
    @favorites  = Shared::Favorite.in_context(@context).by(@user).order(created_at: :desc)
    @activities = Shared::Activity.in_context(@context).of(@user).global.order(created_at: :desc) if current_user == @user
    @activities = Shared::Activity.in_context(@context).of(@user).order(created_at: :desc) unless current_user == @user

    @questions  = @questions.page(tab_page :questions).per(10)
    @anonymous  = @anonymous.page(tab_page :anonymous).per(10)
    @answers    = @answers.page(tab_page :answers).per(10)
    @favorites  = @favorites.page(tab_page :favorites).per(10)
    @activities = @activities.page(tab_page :activities).per(20)

    @question = Shared::Question.in_context(@context).unanswered.random.first || Shared::Question.in_context(@context).random.first
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

  def activities
    from = Date.parse(params[:from]) rescue (Time.now - 1.year).to_date
    to   = Date.parse(params[:to])   rescue (Time.now).to_date

    from, to = to, from if from > to

    @user = Shared::User.by(nick: params[:nick])
    @data = Shared::Activity.data(@user, from: from, to: to, context: @context)

    render json: @data
  end

  def facebook
    @auth    = request.env['omniauth.auth']
    @proxy   = FbGraph::User.me(@auth.credentials.token)
    @friends = @proxy.friends
    @likes   = @proxy.likes

    current_user.from_omniauth(@auth, @friends, @likes)

    redirect_to root_path
  end

  def followings
    @user = Shared::User.by(nick: params[:nick])

    @followees = @user.followees.in_context(@context).order(:nick).page(tab_page :followees).per(20)
    @followers = @user.followers.in_context(@context).order(:nick).page(tab_page :followers).per(20)
  end

  def follow
    @followee = Shared::User.find(params[:id])

    authorize! :follow, @followee

    @following = current_user.toggle_following_by! @followee

    dispatch_event dispatch_event_action_for(@following), @following, for: @followee

    params[:profile] ? redirect_to(:back) : render('follow', formats: :js)
  end

  def suggest
    @users = Shared::User.in_context(@context).where('nick like ?', "#{params[:q]}%")

    render json: @users, root: false
  end

  private

  def user_params
    attributes = [:email, :nick, :about, :gravatar_email, :show_name, :show_email, :read_notifications_thread, :send_email_notifications]

    attributes += Shared::Social.networks.keys
    attributes += [:first, :last] if can? :change_name, current_user
    attributes += [:password, :password_confirmation] if can? :change_password, current_user

    params.require(:user).permit(attributes)
  end
end
end
