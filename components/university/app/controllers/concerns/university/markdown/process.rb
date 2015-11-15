module University::Markdown::Process
  extend ActiveSupport::Concern

  included do
    helper_method :unprocess_markdown_for
  end

  def process_markdown_for(resource, attribute: :text, **options, &callback)
    text = (resource.public_send(attribute) || '').clone

    return if text.empty?

    result = Markdown::Processor.process(text, current_user, &callback)

    resource.public_send(:"#{attribute}=", result)

    resource.save!
  end

  def unprocess_markdown_for(resource, attribute: :text, **options, &callback)
    text = resource.public_send(attribute).clone

    return if text.empty?

    result = Markdown::Processor.unprocess(text, current_user, &callback)

    resource.public_send(:"#{attribute}", result)
  end
end
