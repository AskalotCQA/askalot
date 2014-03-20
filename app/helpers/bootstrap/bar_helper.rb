module Bootstrap::BarHelper
  def navbar_dropdown_tag(type, body, url, options = {}, &block)
    caret = options.delete(:caret)
    body  = icon_tag(caret, label: body, fixed: true, join: :append) if caret
    link  = icon_link_to(type, body, url, class: :'dropdown-toggle', data: { toggle: :dropdown }, fixed: true, join: options.delete(:join))
    list  = content_tag :ul, capture(&block), class: :'dropdown-menu'
    body  = (link << list).html_safe

    navbar_li_tag body, url, options.merge(class: [:dropdown, options.delete(:class)])
  end

  def navbar_li_tag(body, url, options = {})
    classes = Array.wrap options.delete(:class)
    classes << :active if request.fullpath.start_with? url

    content_tag :li, body, options.merge(class: classes.blank? ? nil : classes)
  end

  def navbar_link_tag(type, body, url, options = {})
    navbar_li_tag icon_link_to(type, body, url, fixed: true), url, options
  end

  def navbar_logo_tag(title, options = {})
    classes = [:'navbar-brand']
    classes << :active if current_page? root_path

    link_to title, root_path, class: classes
  end

  def sidebar_tag(options = {}, &block)
    classes = [:sidebar, :'affix-top'] + Array.wrap(options.delete :class)

    content_tag :div, capture(&block), options.deep_merge(id: options.delete(:id) || :sidebar, class: classes, role: :complementary, data: { spy: :affix })
  end
end
