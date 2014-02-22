module Redcurtain
  class Markdown
    cattr_accessor :renderer, :highlighter

    def self.render(text)
      process(text).to_s.html_safe
    end

    def self.strip(text)
      process(text).text
    end

    def self.setup!
      self.renderer    = Redcurtain::Renderer::GitHub
      self.highlighter = Redcurtain::Highlighter::Pygments
    end

    private

    def self.process(text)
      markdown = renderer.render(text)
      document = Nokogiri::HTML(markdown)

      document.search('//pre').each do |pre|
        language = pre[:lang].try(:to_sym)

        pre.replace(highlighter.highlight(pre.text.strip, language: language))
      end

      document
    end
  end
end
