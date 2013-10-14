class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # TODO (smolnar) use locales for message, refactor
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message

    redirect_to root_url
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit :login, :email, :password, :password_confirmation }
  end
end
