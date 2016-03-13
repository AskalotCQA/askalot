module Shared::NewsHelper
  def new_title_preview(new, options = {})
    html_escape truncate(new.title, default_truncate_options.merge(length: 120).merge(options))
  end

  def new_text_preview(new, options = {})
    html_escape preview_content new.description, options.reverse_merge(length: 200)
  end

  def link_to_new(new, options = {})
    news_index_path(tab: :'news')
  end
end
