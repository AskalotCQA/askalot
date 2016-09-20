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
    end

    if resource.is_a? Shared::Deletable
      link_to_deletable resource, body, url, options
    else
      link_to body, url, options
    end
  end

  def engine_url_helpers(resource)
    "#{resource.class.name.deconstantize}::Engine".constantize.routes.url_helpers
  end
end
