module Concerns::Form
  extend ActiveSupport::Concern

  def form_message(type, message, flash: self.flash, key: nil)
    flash = flash[:form] ||= {}
    store = flash[key || :global] ||= []

    store << [type, message]
  end

  def form_error_message(message, flash: self.flash, key: nil)
    form_message(:error, message, flash: flash, key: key)
  end

  def form_error_messages_for(resource, flash: self.flash, key: nil)
    resource.errors.full_messages.each do |message|
      form_error_message(message) if message.present?
    end
  end
end
