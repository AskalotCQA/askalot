module Redcurtain::Highlighter
  class Pygments
    def self.highlight(html, options)
      ::Pygments.highlight(html, lexer: options[:language])
    end
  end
end
