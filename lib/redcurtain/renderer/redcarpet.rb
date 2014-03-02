module Redcurtain::Renderer
  module Redcarpet
    extend self

    def render(content, options = {})
      renderer = Factory.create(options)

      ::Redcarpet::Markdown.new(renderer, options).render(content).html_safe
    end

    class Factory < ::Redcarpet::Render::HTML
      attr_accessor :options

      TAGS = [
        :block_code,
        :block_quote,
        :block_html,
        :footnotes,
        :footnotes_def,
        :header,
        :hrule,
        :list,
        :list_item,
        :paragraph,
        :table,
        :table_row,
        :table_cell,
        :autolink,
        :codespan,
        :double_emphasis,
        :emphasis,
        :image,
        :linebreak,
        :link,
        :raw_html,
        :triple_emphasis,
        :striketrough,
        :superscript,
        :underline,
        :highlight,
        :quote,
        :footnote_ref,
        :entity,
        :normal_text,
        :doc_header,
        :doc_footer
      ]

      def self.create(options = {})
        parent   = options[:renderer] || ::Redcarpet::Render::HTML
        renderer = Class.new(parent)

        options = { allowed_tags: TAGS }.merge(options)

        renderer.instance_eval do
          TAGS.each do |tag|
            next if options[:allowed_tags].include?(tag)

            define_method tag do |*args|
              case tag
              when :paragraph, :header then "#{args.first}\n"
              when :link               then args.third
              else                          args.first
              end
            end
          end
        end

        renderer.new(options)
      end
    end
  end
end
