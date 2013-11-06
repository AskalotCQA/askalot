module FlashHelper
  def flash_type_to_class(type)
    { alert: :danger, error: :danger, notice: :info }[type] || type
  end
end
