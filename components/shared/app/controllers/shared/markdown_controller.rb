module Shared
class MarkdownController < ApplicationController
  def preview
    @text = Shared::Markdown::Processor.process(params[:text])

    render partial: 'preview', locals: { text: @text }
  end
end
end
