module Redcurtain::Renderer
  module Gemoji
    include Redcurtain::Renderer
    extend  self

    def render(content_or_document, options = {})
      document = prepare_document(content_or_document)
      classes  = Array.wrap(options[:class] || :gemoji)
      path     = options[:path]  || '/images/gemoji'
      title    = options[:title] == false ? nil : options[:title] || lambda { |name| name }

      document.at('body').search('*:not(pre)').each do |part|
        content = part.inner_html.gsub(/:[a-z0-9\+\-_]+:/) do |match|
          name = match[1..-2]

          if Emoji.names.include? name
            data = "data-title=\"#{title.call name}\" data-toggle=\"tooltip\" data-placement=\"bottom\" " if title.present?

            "<img class=\"#{classes.join ' '}\" src=\"#{File.join path, "#{name}.png"}\" alt=\"#{name}\" #{data}/>"
          else
            match
          end
        end

        part.inner_html = content
      end

      document
    end
  end
end
