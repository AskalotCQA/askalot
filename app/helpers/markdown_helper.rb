module MarkdownHelper
  def markdown_editor_for(resource, options = {}, &block)
    id = "markdown-#{resource.class.name.underscore}-#{resource.new_record? ? :new : resource.id}"

    render 'markdown/editor', id: id, content: block, help: options[:help].nil? || options[:help], text: options[:text]
  end

  def render_markdown(text, options = {})
    Redcurtain::Markdown.render(text, options)
  end

  def strip_markdown(text, options = {})
    Redcurtain::Markdown.strip(text, options)
  end
end
