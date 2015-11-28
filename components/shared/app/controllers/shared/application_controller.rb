module Shared
class ApplicationController < ActionController::Base
  protected

  # concerns order is significant
  include Shared::Applications::Security
  include Shared::Applications::Flash
  include Shared::Applications::Form
  include Shared::Applications::Tab

  include Shared::Events::Log

  include Shared::Facebook::Modal
  include Shared::Slido::Flash

  # TODO (huna) refactor
  layout 'university/application' if Rails.env == 'development_university'
  layout 'mooc/application' unless Rails.env == 'development_university'

  def current_ability
    @current_ability ||= Shared::Ability.new(current_user)
  end
end
end
