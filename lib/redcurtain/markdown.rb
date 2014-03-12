module Redcurtain
  module Markdown
    extend self

    attr_accessor :renderers

    def renderers
      @renderers ||= [
        Redcurtain::Renderer::Gemoji,
        Redcurtain::Renderer::Redcarpet,
        Redcurtain::Renderer::Pygments
      ]
    end

    def render(content_or_document, options = {})
      options.symbolize_keys!

      renderers.inject(content_or_document) { |result, renderer|
        renderer.render(result, options[renderer.name.to_s.split(/::/).last.downcase.to_sym] || {})
      }.to_s.html_safe
    end

    def strip(content, options = {})
      renderer = ::Redcarpet::Render::StripDown.new

      ::Redcarpet::Markdown.new(renderer, options).render(content).html_safe
    end
  end
end
