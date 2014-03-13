module Redcurtain::Renderer
  module Pygments
    include Redcurtain::Renderer

    extend self

    def render(content_or_document, options = {})
      document = prepare_document(content_or_document)

      document.search('//pre').each do |pre|
        pre.replace ::Pygments.highlight(pre.text.strip, lexer: pre[:lang])
      end

      document
    end
  end
end
