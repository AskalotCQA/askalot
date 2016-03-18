module Shared::TagsHelper
  def link_to_tag(tag, options = {})
    link_to tag.name, shared.questions_path(tags: tag.name), options
  end
end
