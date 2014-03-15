module Concerns::Form
  extend ActiveSupport::Concern

  def form_message(type, message, flash: self.flash, key: nil)
    flash = flash[:form] ||= {}
    store = flash[key || :global] ||= []

    store << [type, message]
  end

  def form_error_message(message, options = {})
    form_message(:error, message, **options)
  end

  def form_error_messages_for(resource, options = {})
    resource.errors.full_messages.each do |message|
      form_error_message(message, **options) if message.present?
    end
  end
end
