module Shared::AttachmentsHelper
  def attachment_info(file)
    "#{icon_tag(:paperclip)} #{attachment_link(file)} (#{attachment_file_size(file)})".html_safe
  end

  def attachment_link(file)
    link_to(file.instance.file_file_name, Rails.application.config.relative_url_root.to_s + file.url, target: '_blank')
  end

  def attachment_file_size(file)
    "#{file.instance.file_file_size / 1024} KB"
  end

  def attachment_details(attachment)
    tooltip_time_tag attachment.created_at, format: :normal, placement: :top
  end
end
