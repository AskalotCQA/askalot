module Redcurtain::Renderer
  module Gemoji
    extend self

    def render(content, options = {})
      content.to_s.gsub(/:[a-z0-9\+\-_]+:/) { |match|
        name = match[1..-2]

        if Emoji.names.include? name
          image_tag(image_path("gemoji/#{name}.png"), class: :gemoji, alt: name)
        else
          match
        end
      }.html_safe
    end
  end
end
