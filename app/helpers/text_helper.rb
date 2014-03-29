module TextHelper
  def default_truncate_options
    { escape: false, omission: '&hellip;', separator: ' ' }
  end

  def extract_truncate_options!(options = {})
    options.extract! :escape, :length, :omission, :separator
  end
end
