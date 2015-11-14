module University::Bootstrap::TooltipHelper
  def tooltip_attributes(title, options = {})
    options.deep_merge title: title, data: { toggle: :tooltip, placement: options.delete(:placement) || :top, trigger: options.delete(:trigger) || :hover }
  end

  def tooltip_tag(body, title, options = {})
    link_to body, '#', tooltip_attributes(title, options)
  end

  def tooltip_icon_tag(type, title, options = {})
    icon_tag type, tooltip_attributes(title, options)
  end

  def tooltip_time_tag(time, options = {})
    options.deep_merge! data: { toggle: :tooltip, placement: options.delete(:placement) || :top, trigger: options.delete(:trigger) || :hover }

    timeago_tag time, options.merge(lang: I18n::locale)
  end
end
