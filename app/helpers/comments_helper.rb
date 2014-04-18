module CommentsHelper
  def link_to_comment(comment, options = {})
    link_to_resource comment, options.merge(anchor: "comment-#{comment.id}")
  end
end
