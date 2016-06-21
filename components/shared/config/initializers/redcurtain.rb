require 'shared/redcurtain'

# renderers order is significant

Redcurtain::Markdown.renderers.unshift(*[
  Redcurtain::Renderer::Replacer.new(:'user-link'),
  Redcurtain::Renderer::Replacer.new(:'question-link'),
  Redcurtain::Renderer::Linker.new(:user),
  Redcurtain::Renderer::Linker.new(:question)
])

[:autolink, :no_styles, :tables].each do |flag|
  Redcurtain::Renderer::Redcarpet.defaults[flag] = true
end

Redcurtain::Renderer::Redcarpet.defaults[:tags] &= [
  :autolink,
  :block_code,
  :block_quote,
  :codespan,
  :double_emphasis,
  :emphasis,
  :header,
  :hrule,
  :image,
  :linebreak,
  :link,
  :list,
  :list_item,
  :normal_text,
  :paragraph,
  :table,
  :table_row,
  :table_cell,
  :quote,
  :striketrough,
  :superscript,
  :underline
]

class ActionView::Template::Handlers::Markdown
  def call(template)
    @erb ||= ActionView::Template.registered_template_handler :erb

    "render_markdown(begin;#{@erb.call template};end)"
  end
end

ActionView::Template.register_template_handler :md, ActionView::Template::Handlers::Markdown.new
