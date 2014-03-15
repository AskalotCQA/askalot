module Redcurtain::Renderer
  module Pygments
    include Redcurtain::Renderer

    extend self

    def render(content, options = {})
      document = Nokogiri::XML("<html><body>#{content}</body></html>")

      document.search('//code').each do |pre|
        pre.replace ::Pygments.highlight(pre.text.strip, lexer: pre[:lang])
      end

      document.at('body').inner_html.html_safe
    end
  end
end
