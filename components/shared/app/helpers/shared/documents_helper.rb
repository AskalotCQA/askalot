module University::DocumentsHelper
  def document_title_preview(document, options = {})
    html_escape truncate(document.title, default_truncate_options.merge(length: 120).merge(options))
  end

  def document_text_preview(document, options = {})
    html_escape preview_content document.text, options.reverse_merge(length: 200)
  end

  def link_to_document(document, options = {})
    link_to document_title_preview(document), document_path(document), options
  end
end
