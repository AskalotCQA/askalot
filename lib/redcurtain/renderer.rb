module Redcurtain
  module Renderer
    extend self

    protected

    def search(content, regex, options = {}, &callback)
      text = content.gsub(/([`]{1,3})[^`]+\1/, '')

      text.scan(regex).each do |match|
        match = match.join if match.is_a?(Array)

        content.gsub!(match, callback.call(match))
      end

      content
    end
  end
end
