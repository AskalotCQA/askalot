module University
class ApplicationController < ActionController::Base
  protected

  # concerns order is significant
  include University::Applications::Security
  include University::Applications::Flash
  include University::Applications::Form
  include University::Applications::Tab

  include University::Events::Log

  include University::Facebook::Modal
  include University::Slido::Flash

  def current_ability
    @current_ability ||= University::Ability.new(current_user)
  end
end
end
