module MarkdownHelper
  def markdown_editor_for(resource, &block)
    id = "markdown-#{resource.class.name.underscore}-#{resource.new_record? ? :new : resource.id}"

    render 'markdown/editor', id: id, content: block
  end

  def render_markdown(text, options = {})
    Redcurtain::Markdown.render(text)
  end

  def markdown_to_text(text)
    Redcurtain::Markdown.strip(text)
  end
end
