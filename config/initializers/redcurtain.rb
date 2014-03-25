# renderers order is significant

Redcurtain::Markdown.renderers.unshift(*[
  Redcurtain::Renderer::Replacer.new(:'user-link'),
  Redcurtain::Renderer::Replacer.new(:'question-link'),
  Redcurtain::Renderer::Linker.new(:user),
  Redcurtain::Renderer::Linker.new(:question)
])

[:autolink, :no_images, :no_styles].each do |flag|
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
    @erb     ||= ActionView::Template.registered_template_handler :erb
    @options ||= { autolink: true, fenced_code_blocks: true, space_after_headers: true }

    "Redcarpet::Markdown.new(Redcarpet::Render::HTML, #{@options.to_s}).render(begin;#{@erb.call template};end)"
  end
end

ActionView::Template.register_template_handler :md, ActionView::Template::Handlers::Markdown.new
