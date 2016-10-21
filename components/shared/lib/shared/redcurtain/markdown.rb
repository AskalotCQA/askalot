module Redcurtain
  module Markdown
    extend self

    attr_accessor :renderers

    def renderers
      @renderers ||= [
        Renderer::MathFixer,
        Renderer::Gemoji,
        Renderer::Redcarpet,
        Renderer::Pygments
      ]
    end

    def render(content_or_document, options = {})
      options.symbolize_keys!

      renderers.inject(content_or_document) do |result, renderer|
        renderer.render(result, options[renderer.name.to_s.split(/::/).last.downcase.to_sym] || {})
      end
    end

    def strip(content, options = {})
      renderer = ::Redcarpet::Render::StripDown.new

      ::Redcarpet::Markdown.new(renderer, options).render(content).html_safe
    end
  end
end
