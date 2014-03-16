module Redcurtain::Renderer
  module Pygments
    include Redcurtain::Renderer

    extend self

    def render(content, options = {})
      document = Nokogiri::HTML(content)

      document.search('//pre').each do |pre|
        block = pre.css('code').first

        pre.replace ::Pygments.highlight(pre.text.strip, lexer: block[:class])
      end

      document.at('body').inner_html.html_safe
    end
  end
end
