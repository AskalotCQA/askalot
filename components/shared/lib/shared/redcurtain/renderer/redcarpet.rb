module Redcurtain::Renderer
  module Redcarpet
    extend self

    attr_accessor :defaults

    def render(content, options = {})
      options  = defaults.deep_merge(options)
      renderer = Factory.create(options)

      ::Redcarpet::Markdown.new(renderer, options).render(content).html_safe
    end

    def defaults
      @defaults ||= { tags: Factory::TAGS.clone, space_after_headers: true, fenced_code_blocks: true, no_intra_emphasis: true }
    end

    class Factory < ::Redcarpet::Render::HTML
      TAGS = [
        :autolink,
        :block_code,
        :block_html,
        :block_quote,
        :codespan,
        :doc_footer,
        :doc_header,
        :double_emphasis,
        :emphasis,
        :entity,
        :footnote_ref,
        :footnotes,
        :footnotes_def,
        :header,
        :highlight,
        :hrule,
        :image,
        :linebreak,
        :link,
        :list,
        :list_item,
        :normal_text,
        :paragraph,
        :quote,
        :raw_html,
        :striketrough,
        :superscript,
        :table,
        :table_cell,
        :table_row,
        :triple_emphasis,
        :underline
      ]

      def self.create(options = {})
        options  = Redcarpet.defaults.deep_merge(options)
        parent   = options[:renderer] || ::Redcarpet::Render::HTML
        renderer = Class.new(parent)

        renderer.instance_eval do
          TAGS.each do |tag|
            next if options[:tags].include?(tag)

            case tag
            when :link               then define_method(tag) { |*args| args.third }
            when :paragraph, :header then define_method(tag) { |*args| "#{args.first}\n"}
            else                          define_method(tag) { |*args| args.first }
            end
          end
        end

        renderer.new(options)
      end
    end
  end
end
