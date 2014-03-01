Redcurtain::Markdown.renderers.unshift(*[
  Redcurtain::Renderer::Linker.new(:user),
  Redcurtain::Renderer::Linker.new(:question)
])
