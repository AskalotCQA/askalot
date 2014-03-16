module Markdown
  extend ActiveSupport::Concern

  def process_markdown_for(resource, attribute: :text, **options, &callback)
    text = resource.public_send(attribute).clone

    return if text.empty?

    result = Markdown::Processor.process(text, current_user, &callback)

    resource.public_send(:"#{attribute}=", result)

    resource.save!
  end
end
