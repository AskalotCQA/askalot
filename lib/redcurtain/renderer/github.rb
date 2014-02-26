module Redcurtain::Renderer
  module GitHub
    extend self

    def render(content, options = {})
      ::GitHub::Markdown.render(content.to_s).html_safe
    end
  end
end
