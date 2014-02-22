module Redcurtain
  class Markdown
    cattr_accessor :renderer, :highlighter

    def self.render(text)
      process(text).to_s.html_safe
    end

    def self.strip(text)
      process(text).text
    end

    private

    def self.process(text)
      markdown = renderer.render(text)
      document = Nokogiri::HTML(markdown)

      document.search('//pre').each do |pre|
        pre.replace(highlighter.highlight(pre.text.strip, language: pre[:lang].to_sym))
      end

      document
    end
  end
end
