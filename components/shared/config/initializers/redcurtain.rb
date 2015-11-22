require 'shared/redcurtain'

# renderers order is significant

Shared::Redcurtain::Markdown.renderers.unshift(*[
  Shared::Redcurtain::Renderer::Replacer.new(:'user-link'),
  Shared::Redcurtain::Renderer::Replacer.new(:'question-link'),
  Shared::Redcurtain::Renderer::Linker.new(:user),
  Shared::Redcurtain::Renderer::Linker.new(:question)
])

[:autolink, :no_images, :no_styles].each do |flag|
  Shared::Redcurtain::Renderer::Redcarpet.defaults[flag] = true
end

Shared::Redcurtain::Renderer::Redcarpet.defaults[:tags] &= [
  :autolink,
  :block_code,
  :block_quote,
  :codespan,
  :double_emphasis,
  :emphasis,
  :header,
  :hrule,
  :linebreak,
  :link,
  :list,
  :list_item,
  :normal_text,
  :paragraph,
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
