class UsersController < ApplicationController
  include Tabbing

  before_action :authenticate_user!

  default_tab :'users-all', only: :index
  default_tab :'user-questions', only: :show

  def index
    @users = case params[:tab].to_sym
             when :'users-all' then User.order(:nick)
             else fail
             end

    @users = @users.page(params[:page]).per(60)
  end

  def show
    @user = User.find_by_nick params[:nick]

    @questions = @user.questions.where(anonymous: false).order(created_at: :desc)
    @answers   = @user.answers.order(created_at: :desc)
    @favorites = Question.favored_by(@user).order(created_at: :desc)

    case params[:tab].to_sym
      when :'user-questions' then @questions = @questions.page(params[:page]).per(10)
      when :'user-answers'   then @answers   = @answers.page(params[:page]).per(10)
      when :'user-favorites' then @favorites = @favorites.page(params[:page]).per(10)
      else fail
      end

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
