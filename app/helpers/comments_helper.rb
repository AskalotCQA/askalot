module CommentsHelper
  def comment_creation_time(comment, options = {})
    tooltip_time_tag comment.created_at, options.merge(format: :normal, placement: :right)
  end
end
