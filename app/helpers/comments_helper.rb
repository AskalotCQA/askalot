module CommentsHelper
  def comment_creation_time(comment, options = {})
    tooltip_time_tag comment.created_at, options.merge(format: :normal, placement: :right)
  end

  def comment_text(comment, options = {})
    render_markdown comment.text, redcarpet: { allowed_tags: [:link, :autolink] }
  end
end
