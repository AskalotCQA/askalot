module Redcurtain
  module Markdown
    extend self

    attr_accessor :renderers

    def setup!
      @renderers = [
        Redcurtain::Renderer::Gemoji,
        Redcurtain::Renderer::GitHub,
        Redcurtain::Highlighter::Pygments
      ]
    end

    def render(content, options = {})
      renderers.inject(content) do |result, renderer|
        renderer.render(result, options)
      end
    end

    def strip(content, options = {})
      Nokogiri::XML(content).text
    end
  end
end
