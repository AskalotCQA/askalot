Redcurtain::Markdown.renderers.unshift(*[
  Redcurtain::Renderer::Linker.of(:user),
  Redcurtain::Renderer::Linker.of(:question)
])
