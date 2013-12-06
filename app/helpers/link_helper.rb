module LinkHelper
  def icon_link_to(type, body, url = nil, options = {})
    link_to icon_tag(type, label: body, fixed: options.delete(:fixed), join: options.delete(:join)), url, options
  end

  def icon_mail_to(type, body, url = nil, options = {})
    url = body if url.blank?

    mail_to url, icon_tag(type, label: body, fixed: options.delete(:fixed), join: options.delete(:join)), options
  end

  def close_link_to(url = nil, options = {})
    link_to icon_tag(:times), url || '#', options.merge(class: :close, aria: { hidden: true })
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
end
