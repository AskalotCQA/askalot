module Redcurtain::Renderer
  class Replacer
    include Redcurtain::Renderer

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def render(content, options = {})
      replacer = options[:replacer]
      regex    = options[:regex]

      unless regex
        raise ArgumentError.new("You need to provide a 'regex' option to match content")
      end

      unless replacer
        raise ArgumentError.new("You need to provide a 'linker' which replaces content match")
      end

      content.to_s.gsub(regex, &replacer)
    end
  end
end
