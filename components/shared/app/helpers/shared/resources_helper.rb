module Shared::ResourcesHelper
  def link_to_resource(resource, options = {})
    body = options.delete(:body)
    url  = options.delete(:url)

    body_options = extract_truncate_options! options
    url_options  = options.extract! :anchor, :params

    if resource.respond_to? :to_question
      question = resource.to_question

      body ||= question_title_preview(question, body_options)
      path ||= options[:absolute_url] ? shared.question_url(question, url_options) : shared.question_path(question, url_options)

      url = url.is_a?(Proc) ? url.call(path) : path
      url = question.page_url_prefix + url if options.delete(:page_url_prefix)
    end

    if resource.is_a? Shared::Deletable
      link_to_deletable resource, body, url, options
    else
      url = options[:current_user].default_askalot_page_url + '#' + url if options[:page_url_prefix] && options[:current_user]

      link_to body, url, options
    end
  end

  def engine_url_helpers(resource)
    "#{resource.class.name.deconstantize}::Engine".constantize.routes.url_helpers
  end

  def unread_resource?(resource, user)
    resource.created_at > user.dashboard_last_sign_in_at
  end
end
