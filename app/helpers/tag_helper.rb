module TagHelper
  def square_tag(type, body, options = {})
    content_tag :span, body, options.merge(class: "label label-#{type.to_s}")
  end

  def round_tag(type, body, options = {})
    content_tag :span, body, options.merge(class: "badge badge-#{type.to_s}")
  end

  def icon_tag(type, options = {})
    classes = ['fa', "fa-#{type.to_s}"]
    classes << 'fa-fw' if options.delete(:fixed)

    icon  = content_tag :i, nil, class: classes
    label = options.delete(:label)

    return icon if label.blank?

    label = label.to_s.html_safe
    join  = options.delete(:join)
    body  = [icon, ' ', label]

    body.reverse! if join == :append
    body.join.html_safe
  end

  def navbar_logo_tag(title, options = {})
    classes = [:'navbar-brand']
    classes << :active if current_page? root_path

    link_to title, root_path, class: classes
  end

  def navbar_li_tag(body, url, options = {})
    classes = Array.wrap options.delete(:class)
    classes << :active if request.fullpath.start_with? url

    content_tag :li, body, options.merge(class: classes.blank? ? nil : classes)
  end

  def navbar_link_tag(type, body, url, options = {})
    navbar_li_tag icon_link_to(type, body, url, fixed: true), url, options
  end

  def navbar_dropdown_tag(type, body, url, options = {}, &block)
    caret = options.delete(:caret)
    body  = icon_tag(caret, label: body, fixed:true, join: :append) if caret
    link  = icon_link_to(type, body, url, class: :'dropdown-toggle', data: { toggle: :dropdown }, fixed: true, join: options.delete(:join))
    list  = content_tag :ul, capture(&block), class: :'dropdown-menu'
    body  = (link << list).html_safe

    navbar_li_tag body, url, options.merge(class: :dropdown)
  end

  def popover_tag(body, content, options = {})
    options.deep_merge! data: { toggle: :popover, content: content, html: true, placement: options.delete(:placement) || :top, trigger: options.delete(:trigger) || :click }

    link_to body, '#', options
  end

  def tooltip_tag(body, title, options = {})
    options.deep_merge! data: { toggle: :tooltip, placement: options.delete(:placement) || :top, trigger: options.delete(:trigger) || :hover }

    link_to body, '#', options.merge(title: title)
  end

  def tooltip_time_tag(time, options = {})
    options.deep_merge! data: { toggle: :tooltip, placement: options.delete(:placement) || :top, trigger: options.delete(:trigger) || :hover }

    timeago_tag time, options.merge(lang: I18n::locale)
  end
end
