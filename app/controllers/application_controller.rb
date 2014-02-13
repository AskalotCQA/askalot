class ApplicationController < ActionController::Base
  protected

  include Concerns::Security
  include Concerns::Logging
  include Concerns::Flash
  include Concerns::Slido
end
