module Redcurtain::Renderer
  class Linker
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def render(content, options)
      linker  = options[:linker]
      regex   = options[:regex] || /@\w+/

      unless linker
        raise ArgumentError.new("You need to provide a 'linker' option to translate content references")
      end

      content.gsub(regex) { |match|
        linker.call(match) || match
      }.html_safe
    end
  end
end
