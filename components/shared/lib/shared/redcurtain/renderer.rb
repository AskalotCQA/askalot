module Shared::Redcurtain
  module Renderer
    extend self

    protected

    def search(content, regex, options = {}, &callback)
      text = content.gsub(/([`]{1,3})[^`]+\1/) { |match| ' ' * match.length }

      text.scan(regex).each do |match|
        offset = 0
        match  = match.join if match.is_a?(Array)
        value  = callback.call(match)

        while index = text.index(match, offset)
          length = index + match.length - 1

          text[index..length] = content[index..length] = value

          offset += value.length + 1
        end
      end

      content
    end
  end
end
