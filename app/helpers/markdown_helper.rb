module MarkdownHelper
  def markdown_editor_for(resource, options = {}, &block)
    id = "markdown-#{resource.class.name.underscore}-#{resource.new_record? ? :new : resource.id}"

    render 'markdown/editor', id: id, content: block, help: options[:help].nil? || options[:help], text: options[:text]
  end

  def render_markdown(text, options = {})
    options.merge! user: {
      linker: lambda { |match| markdown_link_to_user(match) }
    }

    options.merge! question: {
      linker: lambda { |match| markdown_link_to_question(match) },
      regex:  /#\w+/
    }

    Redcurtain::Markdown.render(text, options)
  end

  def strip_markdown(text, options = {})
    Redcurtain::Markdown.strip(text, options)
  end

  def markdown_link_to_user(match, options = {})
    nick = match.gsub(/@/, '')
    user = User.find_by(nick: nick)

    link_to match, user_path(user.nick) if user
  end

  def markdown_link_to_question(match, options = {})
    id       = match.gsub(/#/, '')
    question = Question.find_by(id: id)

    link_to match, question if question
  end
end
