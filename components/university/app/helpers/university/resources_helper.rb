module University::ResourcesHelper
  def link_to_resource(resource, options = {})
    body = options.delete(:body)
    url  = options.delete(:url)

    body_options = extract_truncate_options! options
    url_options  = options.extract! :anchor, :params

    if resource.respond_to? :to_question
      question = resource.to_question

      body ||= question_title_preview(question, body_options)
      path ||= question_path(question, url_options)

      url = url.is_a?(Proc) ? url.call(path) : path
    end

    if resource.is_a? Deletable
      link_to_deletable resource, body, url, options
    else
      link_to body, url, options
    end
  end
end
