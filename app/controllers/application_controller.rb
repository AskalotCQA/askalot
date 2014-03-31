class ApplicationController < ActionController::Base
  protected

  # concerns order is significant
  include Applications::Security
  include Applications::Flash
  include Applications::Form
  include Applications::Tab

  include Events::Log

  include Slido::Flash
end
