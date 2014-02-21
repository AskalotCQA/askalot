class MarkdownController < ApplicationController
  def preview
    @text = params[:text]

    render partial: 'preview'
  end
end
