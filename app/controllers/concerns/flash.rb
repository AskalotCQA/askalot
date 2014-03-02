module Concerns::Flash
  extend ActiveSupport::Concern

  def flash_error_messages_for(resource, flash: self.flash, **options)
    messages = resource.errors.full_messages

    flash[:error] = Array.wrap(flash[:error]) + messages.reject(&:blank?) unless messages.empty?
  end
end
