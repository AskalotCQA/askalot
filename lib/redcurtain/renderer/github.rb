module Redcurtain::Renderer
  class GitHub
    def self.render(text, options = {})
      GitHub::Markdown.render(text)
    end
  end
end
