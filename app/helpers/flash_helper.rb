module FlashHelper
  include FormHelper

  alias :flash_message_type_to_class :form_message_type_to_class

  def flash_messages(flash: self.flash)
    messages = []

    flash.each do |type, value|
      next if type == :form

      Array.wrap(value).each do |message|
        messages << [type, message]
      end
    end

    render 'shared/flash_messages', messages: messages
  end
end
