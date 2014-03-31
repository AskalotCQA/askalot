class ApplicationController < ActionController::Base
  protected

  # concerns order is significant
  include Concerns::Analytics
  include Concerns::Security
  include Concerns::Log
  include Concerns::Flash
  include Concerns::Form
  include Concerns::Slido
end
