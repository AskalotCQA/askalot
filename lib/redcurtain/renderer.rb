module Redcurtain
  module Renderer
    extend self

    def prepare_document(content_or_document)
      return content_or_document if content_or_document.is_a?(Nokogiri::XML::Document)

      Nokogiri::XML(Nokogiri::HTML(content_or_document).inner_html)
    end
  end
end
