module Redcurtain::Renderer
  class Linker
    include Redcurtain::Renderer

    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def render(content_or_document, options = {})
      document = prepare_document(content_or_document)

      linker  = options[:linker]
      regex   = options[:regex] || /(^|\s+)(@\w+)/

      unless linker
        raise ArgumentError.new("You need to provide a 'linker' option to translate content references")
      end

      document.at('body').search('*:not(pre)').each do |part|
        content = part.inner_html.gsub(regex) do |match|
          result = linker.call(match)

          if result
            spaces = match.match(/\A\s+/)

            "#{spaces}#{result}"
          else
            match
          end
        end

        part.inner_html = content
      end

      document
    end
  end
end
