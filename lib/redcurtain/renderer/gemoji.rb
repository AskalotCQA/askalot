module Redcurtain::Renderer
  module Gemoji
    extend self

    def render(content, options = {})
      classes = Array.wrap(options[:class] || :gemoji)
      path    = options[:path]  || '/images/gemoji'
      title   = options[:title] || lambda { |name| name }

      content.to_s.gsub(/(^|[^`]{0,3}\s+):[a-z0-9\+\-_]+:($|[^`]{0,3}+)/) { |match|
        name = match[1..-2]

        if Emoji.names.include? name
          data = "data-title=\"#{title.call name}\" data-toggle=\"tooltip\" data-placement=\"bottom\" " if title.present?

          "<img class=\"#{classes.join ' '}\" src=\"#{File.join path, "#{name}.png"}\" alt=\"#{name}\" #{data}/>"
        else
          match
        end
      }.html_safe
    end
  end
end
