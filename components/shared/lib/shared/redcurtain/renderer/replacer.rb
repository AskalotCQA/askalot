module Shared::Redcurtain::Renderer
  class Replacer
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def render(content, options = {})
      content     = content
      regex       = options[:regex]
      replacement = options[:replacement]

      raise ArgumentError.new "You need to provide a 'regex' option to match content" unless regex
      raise ArgumentError.new "You need to provide a 'linker' which replaces content match" unless replacement

      content.to_s.gsub(regex, &replacement).html_safe
    end
  end
end
