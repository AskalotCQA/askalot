module Redcurtain::Renderer
  module Redcarpet
    extend self

    def render(content, options = {})
      renderer = ::Redcarpet::Render::HTML.new(options)

      ::Redcarpet::Markdown.new(renderer).render(content).html_safe
    end
  end
end
