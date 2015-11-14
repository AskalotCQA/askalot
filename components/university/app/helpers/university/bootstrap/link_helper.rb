module University::Bootstrap::LinkHelper
  def close_link_to(url = nil, options = {})
    link_to icon_tag(:times), url || '#', options.merge(class: :close, :'aria-hidden' => true )
  end

  def close_link_to_alert(options = {})
    close_link_to nil, options.deep_merge(data: { dismiss: :alert })
  end

  def close_link_to_modal(options = {})
    close_link_to nil, options.deep_merge(data: { dismiss: :modal })
  end

  def external_link_to(body, url = nil, options = {})
    icon = options.delete(:icon)

    return link_to body, url, options.merge(target: :_blank) unless icon

    icon_link_to icon == true ? :'external-link' : icon, body, url, options.merge(target: :_blank, join: :append)
  end

  def link_to_with_count(body, url, count, options = {})
    count = content_tag :span, "&nbsp;(#{number_with_delimiter count})".html_safe, class: :'text-muted' if count.is_a? Integer

    link_to body.concat(count).html_safe, url, options
  end
end
