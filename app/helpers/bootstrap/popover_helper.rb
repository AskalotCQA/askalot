module Bootstrap::PopoverHelper
  def popover_attributes(content, options = {})
    options.deep_merge data: { toggle: :popover, content: content, html: true, placement: options.delete(:placement) || :top, trigger: options.delete(:trigger) || :click }
  end

  def popover_tag(body, content, options = {})
    link_to body, '#', popover_attributes(content, options)
  end
end
