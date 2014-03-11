module Redcurtain::Renderer
  module Pygments
    extend self

    def render(content_or_document, options = {})
      document = content_or_document.is_a?(Nokogiri::XML::Document) ? content_or_document : Nokogiri::XML(Nokogiri::HTML(content_or_document).to_s)

      document.search('//pre').each do |pre|
        pre.replace ::Pygments.highlight(pre.text.strip, lexer: pre[:lang])
      end

      document
    end
  end
end
