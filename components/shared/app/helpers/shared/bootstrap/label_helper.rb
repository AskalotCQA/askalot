module Shared::Bootstrap::LabelHelper
  def badge_tag(body, options = {})
    content_tag :span, body, options.merge(class: [:badge] + Array.wrap(options.delete :class))
  end

  def square_tag(type, body, options = {})
    content_tag :span, body, options.merge(class: "label label-#{type.to_s}")
  end
end
