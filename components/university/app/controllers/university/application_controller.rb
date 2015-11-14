module University
class ApplicationController < ActionController::Base
  protected

  # concerns order is significant
  include University::Concerns::Applications::Security
  include University::Concerns::Applications::Flash
  include University::Concerns::Applications::Form
  include University::Concerns::Applications::Tab

  # include University::Concerns::Events::Log

  include University::Concerns::Facebook::Modal
  include University::Concerns::Slido::Flash
end
end
