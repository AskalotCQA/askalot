module Mooc::MarkdownHelper
  extend Shared::MarkdownHelper

  def markdown_editor_for_unit(resource, page_url = nil, options = {}, &block)
    id = "markdown-#{resource.class.name.demodulize.underscore}-#{resource.new_record? ? :new : resource.id}"
    redirect = page_url ?  page_url + '#' : ''

    options.merge!(target: '_parent')

    render 'mooc/markdown/editor', id: id, redirect: redirect, content: block, help: options[:help].nil? || options[:help], text: options[:text]
  end

  def markdown_unit_link_to_question(match, page_url, options = {})
    id       = match[/\d+\z/] || match.gsub(/#/, '')
    question = Shared::Question.find_by(id: id)
    href     = (page_url ? page_url + '#' : '') + shared.question_path(question) if question

    link_to "##{id}", href if question
  end

  def markdown_unit_link_to_user(match, page_url, options = {})
    id       = match[/\d+\z/] || match.gsub(/@/, '')
    user     = Shared::User.find_by(id: id)
    href     = (page_url ? page_url + '#' : '') + shared.user_path(user.nick) if user

    link_to "@#{user.nick}", href if user
  end
end
