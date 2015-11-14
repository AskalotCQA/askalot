module University::Bootstrap::UtilityHelper
  def clearfix_tag(options = {})
    content_tag :div, nil, options.merge(class: Array.wrap(options[:class]) << :clearfix)
  end

  def find_tag(content, selector)
    result = Nokogiri::XML(content).css(selector.to_s)
    result = yield result if block_given?
    result
  end
end
