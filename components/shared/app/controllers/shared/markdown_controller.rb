module Shared
class MarkdownController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def preview
    @text = Shared::Markdown::Processor.process(params[:text])

    render partial: 'preview', locals: { text: @text }
  end
end
end
