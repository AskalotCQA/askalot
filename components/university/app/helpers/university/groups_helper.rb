module University::GroupsHelper
  def group_title_preview(group, options = {})
    html_escape truncate(group.title, default_truncate_options.merge(length: 50).merge(options))
  end

  def link_to_group(group, options = {})
    link_to group_title_preview(group), group_path(group), options
  end
end
