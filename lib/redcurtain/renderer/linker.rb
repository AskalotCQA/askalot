module Redcurtain::Renderer
  module Linker
    extend self

    def render(content, options)
      linker    = options[:linker]
      reference = options[:reference] || /@/
      regex     = options[:regex] || /#{reference}\w+/

      unless linker
        throw ArgumentError.new("You need to provide a 'linker' option to translate content references")
      end

      content.gsub(regex) do |match|
        linker.call(match.gsub(reference, ''))
      end
    end
  end
end
