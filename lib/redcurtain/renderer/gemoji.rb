module Redcurtain::Renderer
  module Gemoji
    extend self

    def render(content, options = {})
      classes = Array.wrap(options[:class] || :gemoji)
      path    = options[:path] || '/images/gemoji'

      content.to_s.gsub(/(^|[^`]{0,3}\s+):[a-z0-9\+\-_]+:($|[^`]{0,3}+)/) { |match|
        name = match[1..-2]

        if Emoji.names.include? name
          "<img class=\"#{classes.join ' '}\" src=\"#{File.join path, "#{name}.png"}\" alt=\"#{name}\" />"
        else
          match
        end
      }.html_safe
    end
  end
end
