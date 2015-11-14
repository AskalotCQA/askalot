module University
class MarkdownController < ApplicationController
  def preview
    @text = Markdown::Processor.process(params[:text])

    render partial: 'preview', locals: { text: @text }
  end
end
end
