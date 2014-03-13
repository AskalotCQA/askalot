module MarkdownHelper
  def markdown_editor_for(resource, options = {}, &block)
    id = "markdown-#{resource.class.name.underscore}-#{resource.new_record? ? :new : resource.id}"

    render 'markdown/editor', id: id, content: block, help: options[:help].nil? || options[:help], text: options[:text]
  end

  def render_markdown(text, options = {})
    options.deep_merge! :'user-link' => {
      regex: /http.*\/users\/\w+/,
      replacer: lambda { |match| (user = User.find_by(nick: match[/\w+\z/])) ? "@#{user.id}" : match }
    }

    options.deep_merge! :'question-link' => {
      regex: /http.*\/questions\/\d+/,
      replacer: lambda { |match| "##{match[/\d+\z/]}" }
    }

    options.deep_merge! user: {
      linker: lambda { |match| markdown_link_to_user(match) },
      regex: /(^|\s)(@\d+)/
    }

    options.deep_merge! question: {
      linker: lambda { |match| markdown_link_to_question(match) },
      regex: /(^|\s)(#\d+)/
    }

    Redcurtain::Markdown.render(text, options)
  end

  def render_stripdown(text, options = {})
    Redcurtain::Markdown.strip(text, options)
  end

  def markdown_link_to_user(match, options = {})
    id   = match[/\d+\z/] || match.gsub(/@/, '')
    user = User.find_by(id: id)

    link_to "@#{user.nick}", user_path(user.nick) if user
  end

  def markdown_link_to_question(match, options = {})
    id       = match[/\d+\z/] || match.gsub(/#/, '')
    question = Question.find_by(id: id)

    link_to "##{id}", question if question
  end
end
