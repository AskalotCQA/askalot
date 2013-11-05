module FlashHelper
  include Concerns::Flash

  def flash_type_to_class(type)
    { alert: :danger, error: :danger, notice: :info }[type] || type
  end

  def devise_error_messages!
    flash_error_messages_for resource

    nil
  end
end
