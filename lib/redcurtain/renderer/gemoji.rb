module Redcurtain::Renderer
  module Gemoji
    extend self

    def render(content, options = {})
      classes = Array.wrap(options[:class] || :gemoji)
      path    = options[:path] || '/images/gemoji'

      content.to_s.gsub(/:[a-z0-9\+\-_]+:/) { |match|
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
