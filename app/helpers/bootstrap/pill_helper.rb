module Bootstrap::PillHelper
  def pill_link_tag(title, tab, path, options = {})
    tab_link_tag title, tab, path, options.deep_merge(data: { toggle: :pill })
  end

  def pill_link_tag_with_count(body, tab, path, count, options = {})
    tab_link_tag_with_count body, tab, path, count, options.deep_merge(data: { toggle: :pill })
  end
end
