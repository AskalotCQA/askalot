module Shared::Applications::Form
  extend ActiveSupport::Concern

  def form_message(type, message, flash: self.flash, key: nil)
    flash = flash[:form] ||= {}
    key   = (key || :global).to_sym
    store = flash[key] ||= []

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
