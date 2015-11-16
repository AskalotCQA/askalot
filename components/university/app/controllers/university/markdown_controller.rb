module University
class MarkdownController < ApplicationController
  def preview
    @text = University::Markdown::Processor.process(params[:text])

    render partial: 'preview', locals: { text: @text }
  end
end
end
