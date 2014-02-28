module Redcurtain::Renderer
  module Linker
    extend self

    def defaults
      @defaults ||= { regex: /@\w+/ }
    end

    def render(content, options)
      options = defaults.merge(options)
      linker  = options[:linker]
      regex   = options[:regex]

      unless linker
        raise ArgumentError.new("You need to provide a 'linker' option to translate content references")
      end

      content.gsub(regex) do |match|
        linker.call(match) || match
      end
    end

    def of(name)
      Base.new(name)
    end
  end

  class Base
    include Linker

    attr_accessor :name

    def initialize(name)
      @name = name
    end
  end
end
