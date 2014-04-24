module Bootstrap::BarHelper
  def navbar_dropdown_tag(type, body, url, options = {}, &block)
    caret = options.delete(:caret)
    body  = icon_tag(caret, label: body, fixed: true, join: :append) if caret
    link  = icon_link_to(type, body, url, class: :'dropdown-toggle', data: { toggle: :dropdown }, fixed: true, join: options.delete(:join))
    list  = content_tag :ul, capture(&block), class: :'dropdown-menu'
    body  = (link << list).html_safe

    navbar_li_tag body, options.merge(class: [:dropdown, options.delete(:class)], url: url)
  end

  def navbar_li_tag(body = nil, options = {}, &block)
    classes = Array.wrap options.delete(:class)
    classes << :active if request.fullpath == options.delete(:url)

    content_tag :li, body || capture(&block), options.merge(class: classes.blank? ? nil : classes)
  end

  def navbar_link_tag(body, url, options = {})
    navbar_li_tag link_to(body, url), options.merge(url: url)
  end

  def navbar_logo_tag(title, options = {})
    classes = [:'navbar-brand']
    classes << :active if current_page? root_path

    link_to title, root_path, class: classes
  end

  def sidebar_tag(options = {}, &block)
    classes = [:sidebar] + Array.wrap(options.delete :class)
    offsets = options.delete(:offset) || {}
    data    = { spy: :affix }

    classes << :'affix-top'

    data[:'offset-top']    = offsets[:top]    if offsets[:top]
    data[:'offset-bottom'] = offsets[:bottom] if offsets[:bottom]

    content_tag :div, capture(&block), options.deep_merge(id: options.delete(:id) || :sidebar, class: classes, role: :complementary, data: data)
  end
end
