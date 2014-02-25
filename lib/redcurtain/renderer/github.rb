module Redcurtain::Renderer
  module GitHub
    extend self

    def self.render(text, options = {})
      ::GitHub::Markdown.render(text)
    end
  end
end
