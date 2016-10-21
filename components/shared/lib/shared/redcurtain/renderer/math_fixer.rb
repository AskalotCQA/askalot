module Redcurtain::Renderer
  module MathFixer
    include Redcurtain::Renderer

    extend self

    def render(content, options = {})
      matches = content.to_s.scan(/(?<!\\)(\$\$?)(.+?)\1/)

      matches.each { |match| content = replace(content, match[1]) }

      matches = content.scan(/(?<!\\)(\\\\\[)(.+?)(\\\\\])/)

      matches.each { |match| content = replace(content, match[1]) }

      matches = content.scan(/(?<!\\)(\\\\\()(.+?)(\\\\\))/)

      matches.each { |match| content = replace(content, match[1]) }

      matches = content.scan(/(?<!\\)(\[mathjax\]|\[mathjaxinline\])(.+?)(\[\/mathjax\]|\[\/mathjaxinline\])/)

      matches.each { |match| content = replace(content, match[1]) }

      content.html_safe
    end

    private

    def replace(content, match)
      m = match.gsub('\\\\', '\\\\\\\\\\\\\\\\\\').gsub(/(?<!\\)_/, '\_').gsub(/(?<!\\)\*/, '\\*')

      content.gsub(/#{Regexp.escape(match)}/, m)
    end
  end
end
