module Redcurtain::Highlighter
  module Pygments
    extend self

    def highlight(html, options)
      ::Pygments.highlight(html, lexer: options[:language])
    end
  end
end
