module MarkdownHelper
  def markdown_editor_for(resource, options = {}, &block)
    id = "markdown-#{resource.class.name.underscore}-#{resource.new_record? ? :new : resource.id}"

    render 'markdown/editor', id: id, content: block, help: options[:help].nil? || options[:help], text: options[:text]
  end

  def render_markdown(text, options = {})
    options.deep_merge! user: {
      linker: lambda { |match| markdown_link_to_user(match) },
      regex: /(^|\s)(@\w+|http.*\/users\/[A-Za-z0-9_]+($|\s))/
    }

    options.deep_merge! question: {
      linker: lambda { |match| markdown_link_to_question(match) },
      regex: /(^|\s)(#\w+|http.*\/questions\/[0-9_]+($|\s))/
    }

    Redcurtain::Markdown.render(text, options)
  end

  def strip_markdown(text, options = {})
    Redcurtain::Markdown.strip(text, options)
  end

  def markdown_link_to_user(match, options = {})
    nick = match[/[A-Za-z0-9]+\z/] || match.gsub(/@/, '')
    user = User.find_by(nick: nick)

    link_to "@#{nick}", user_path(user.nick) if user
  end

  def markdown_link_to_question(match, options = {})
    id       = match[/([0-9]+\z)/] || match.gsub(/#/, '')
    question = Question.find_by(id: id)

    link_to "##{id}", question if question
  end
end
