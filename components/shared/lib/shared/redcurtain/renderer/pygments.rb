module Shared::Redcurtain::Renderer
  module Pygments
    include Shared::Redcurtain::Renderer

    extend self

    def render(content, options = {})
      document = Nokogiri::HTML(content)

      document.search('//pre').each do |pre|
        block = pre.css('code').first

        pre.replace ::Pygments.highlight(pre.text.strip, lexer: block[:class])
      end

      body = document.at('body')

      body.inner_html.html_safe if body
    end
  end
end
