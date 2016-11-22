module Redcurtain::Renderer
  module MathFixer
    include Redcurtain::Renderer

    extend self

    def render(content, options = {})
      matches = content.to_s.scan(/(?<!\\)(\$\$?)(.+?)(\$\$?)/)

      matches.each { |match| content = replace(content, match[0] + match[1] + match[2]) }

      matches = content.scan(/(?<!\\)(\\\\\[)(.+?)(\\\\\])/)

      matches.each { |match| content = replace(content, match[0] + match[1] + match[2]) }

      matches = content.scan(/(?<!\\)(\\\\\()(.+?)(\\\\\))/)

      matches.each { |match| content = replace(content, match[0] + match[1] + match[2]) }

      matches = content.scan(/(?<!\\)(\[mathjax\]|\[mathjaxinline\])(.+?)(\[\/mathjax\]|\[\/mathjaxinline\])/)

      matches.each { |match| content = replace(content, match[0] + match[1] + match[2]) }

      content.html_safe
    end

    private

    def replace(content, match)
      m = match.gsub('\\\\', '\\\\\\\\\\\\\\\\\\').gsub(/(?<!\\)_/, '\_').gsub(/(?<!\\)\*/, '\\*')

      content.gsub(/#{Regexp.escape(match)}/, m)
    end
  end
end
