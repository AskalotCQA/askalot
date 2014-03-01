module Redcurtain
  module Markdown
    extend self

    attr_accessor :renderers

    def renderers
      @renderers ||= [
        Redcurtain::Renderer::Gemoji,
        Redcurtain::Renderer::GitHub,
        Redcurtain::Renderer::Pygments,
      ]
    end

    def render(content, options = {})
      options.symbolize_keys!

      renderers.inject(content) do |result, renderer|
        renderer.render(result, options[renderer.name.to_s.split(/::/).last.downcase.to_sym] || {})
      end
    end

    def strip(content, options = {})
      Nokogiri::XML(content).text.strip
    end
  end
end
