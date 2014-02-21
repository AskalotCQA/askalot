module MarkdownHelper
  def markdown_editor_for(resource, &block)
    id = "markdown-#{resource.class.name.underscore}-#{resource.new_record? ? :new : resource.id}"

    render 'markdown/editor', id: id, content: block
  end

  def render_markdown(text, options = {})
    # TODO (smolnar) move to lib

    markdown = GitHub::Markdown.render(text)
    document = Nokogiri::HTML(markdown)

    document.search('//pre').each do |pre|
      pre.replace(Pygments.highlight(pre.text.strip, lexer: pre[:lang]))
    end

    document.to_s.html_safe
  end
end
