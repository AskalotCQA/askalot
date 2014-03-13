# Order of renders matters

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
