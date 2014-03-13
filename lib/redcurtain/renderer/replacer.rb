module Redcurtain::Renderer
  class Replacer
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def render(content_or_document, options = {})
      content     = content_or_document.to_s
      regex       = options[:regex]
      replacement = options[:replacement]

      raise ArgumentError.new "You need to provide a 'regex' option to match content" unless regex
      raise ArgumentError.new "You need to provide a 'linker' which replaces content match" unless replacement

      content.to_s.gsub(regex, &replacement)
    end
  end
end
