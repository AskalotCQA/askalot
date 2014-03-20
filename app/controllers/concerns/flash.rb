module Concerns::Flash
  extend ActiveSupport::Concern

  included do
    add_flash_types :error
  end

  def flash_error_messages_for(resource, flash: self.flash)
    messages = resource.errors.full_messages

    flash[:error] = Array.wrap(flash[:error]) + messages.reject(&:blank?) unless messages.empty?
  end
end
