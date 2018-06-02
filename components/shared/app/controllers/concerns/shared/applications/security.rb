module Shared
  module Applications::Security
  extend ActiveSupport::Concern

  included do
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    before_action :filter_params

    before_action :permit_params, if: :devise_controller?

    rescue_from CanCan::AccessDenied do |exception|
      flash[:alert] = t('cancan.access_denied')

      redirect_to root_path
    end
  end

  def filter_params
    params.delete :_
  end

  def permit_params
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit :login, :email, :password, :password_confirmation }
    # TODO (smolnar) use users_controller update method
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit :email, :password, :password_confirmation, :current_password }
  end
end
end
