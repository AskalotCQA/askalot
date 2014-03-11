module Redcurtain::Renderer
  class Linker
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def render(content_or_document, options = {})
      document = content_or_document.is_a?(Nokogiri::XML::Document) ? content_or_document : Nokogiri::XML(Nokogiri::HTML(content_or_document).to_s)

      linker  = options[:linker]
      regex   = options[:regex] || /(^|\s+)(@\w+)/

      unless linker
        raise ArgumentError.new("You need to provide a 'linker' option to translate content references")
      end

      document.at('body').search('*:not(pre)').each do |part|
        content = part.to_s.gsub(regex) do |match|
          result = linker.call(match)

          if result
            spaces = match.match(/\A\s+/)

            "#{spaces}#{result}"
          else
            match
          end
        end

        part.replace(content)
      end

      document.at('body')
    end
  end
end
