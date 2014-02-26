module Redcurtain::Highlighter
  module Pygments
    extend self

    def render(content, options = {})
      document = Nokogiri::HTML(content.to_s)

      document.search('//pre').each do |pre|
        language = pre[:lang].try(:to_sym)

        pre.replace ::Pygments.highlight(pre.text.strip, lexer: language)
      end

      document.to_s.html_safe
    end
  end
end
