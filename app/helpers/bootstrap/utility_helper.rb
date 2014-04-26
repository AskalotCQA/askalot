module Bootstrap::UtilityHelper
  def clearfix_tag(options = {})
    content_tag :div, nil, options.merge(class: Array.wrap(options[:class]) << :clearfix)
  end
end
