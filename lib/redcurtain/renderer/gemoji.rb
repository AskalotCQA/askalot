module Redcurtain::Renderer
  module Gemoji
    include Redcurtain::Renderer

    extend self

    def render(content, options = {})
      classes = Array.wrap(options[:class] || :gemoji)
      path    = options[:path]  || '/images/gemoji'
      title   = options[:title] == false ? nil : options[:title] || lambda { |name| name }

      search(content, /:[a-z0-9\+\-_]+:/) { |match|
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
