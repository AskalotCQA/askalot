module Shared::Redcurtain::Renderer
  class Linker
    include Shared::Redcurtain::Renderer

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def render(content, options = {})
      linker = options[:linker]
      regex  = options[:regex] || /(^|\s+)(@\w+)/

      raise ArgumentError.new "You need to provide a 'linker' option to translate content references" unless linker

      search(content, regex) { |match|
        result = linker.call(match)

        if result
          spaces = match.match(/\A\s+/)

          "#{spaces}#{result}"
        else
          match
        end
      }.html_safe
    end
  end
end
