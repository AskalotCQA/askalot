Redcurtain::Markdown.renderers.unshift(*[
  Redcurtain::Renderer::Linker.new(:user),
  Redcurtain::Renderer::Linker.new(:question)
])

[:autolink, :no_images, :no_styles].each do |flag|
  Redcurtain::Renderer::Redcarpet.defaults[flag] = true
end

Redcurtain::Renderer::Redcarpet.defaults[:tags] &= [
  :autolink,
  :block_code,
#  :block_html,
  :block_quote,
  :codespan,
#  :doc_footer,
#  :doc_header,
#  :double_emphasis,
  :emphasis,
#  :entity,
#  :footnote_ref,
#  :footnotes,
#  :footnotes_def,
#  :header,
#  :highlight,
  :hrule,
#  :image,
  :linebreak,
  :link,
  :list,
  :list_item,
  :normal_text,
  :paragraph,
  :quote,
#  :raw_html,
  :striketrough,
  :superscript,
#  :table,
#  :table_cell,
#  :table_row,
#  :triple_emphasis,
  :underline
]
