class MarkdownController < ApplicationController
  def preview
    render partial: 'preview', locals: { text: params[:text] }
  end
end
