module Shared::TextHelper
  def default_truncate_options
    { escape: false, omission: '&hellip;', separator: ' ' }
  end

  def extract_truncate_options!(options = {})
    options.extract! :escape, :length, :omission, :separator
  end

  def preview_content(content, options = {})
    # TODO(zbell) to enable MD here, the whole MD processing must be refactored, render_stripdown(render_markdown(truncate content, default_truncate_options.merge(length: 200).merge(options)))
    truncate content, default_truncate_options.merge(length: 200).merge(options)
  end
end
