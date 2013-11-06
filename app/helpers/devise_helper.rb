module DeviseHelper
  include Concerns::Flash

  def devise_error_messages!
    flash_error_messages_for resource

    nil
  end
end
