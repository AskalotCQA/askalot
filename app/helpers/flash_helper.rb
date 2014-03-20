module FlashHelper
  include FormHelper

  alias :flash_message_type_to_class :form_message_type_to_class

  def flash_messages(flash = self.flash)
    render 'shared/flash_messages', messages: flash_to_messages(flash)
  end

  def flash_to_messages(flash = self.flash)
    messages = []

    flash.each do |type, value|
      next if type == :form

      Array.wrap(value).each do |message|
        messages << [type, message]
      end
    end

    messages
  end
end
