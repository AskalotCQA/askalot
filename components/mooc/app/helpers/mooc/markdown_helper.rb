module Mooc::MarkdownHelper
  extend Shared::MarkdownHelper

  def markdown_editor_for_unit(resource, page_url = nil, options = {}, &block)
    id = "markdown-#{resource.class.name.demodulize.underscore}-#{resource.new_record? ? :new : resource.id}"
    options.merge!(target: '_parent')
    redirect = page_url ?  page_url + '?redirect=' : ''

    render 'mooc/markdown/editor', id: id, redirect: redirect, content: block, help: options[:help].nil? || options[:help], text: options[:text]
  end
end
