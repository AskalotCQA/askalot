module Shared::Bootstrap::IconHelper
  def icon_tag(type, options = {})
    classes = ['fa', "fa-#{type.to_s}"]
    classes << 'fa-fw' if options.delete(:fixed)
    classes += Array.wrap(options.delete :class)

    icon  = content_tag :i, nil, class: classes, data: options[:data], title: options[:title]
    label = options.delete(:label)

    return icon if label.blank?

    label = label.to_s.html_safe
    join  = options.delete(:join)
    body  = [icon, ' ', label]

    body.reverse! if join == :append
    body.join.html_safe
  end

  def icon_link_to(type, body, url = nil, options = {})
    link_to icon_tag(type, label: body, fixed: options.delete(:fixed), join: options.delete(:join)), url, options
  end

  def icon_mail_to(type, body, url = nil, options = {})
    url = body if url.blank?

    mail_to url, icon_tag(type, label: body, fixed: options.delete(:fixed), join: options.delete(:join)), options
  end
end
