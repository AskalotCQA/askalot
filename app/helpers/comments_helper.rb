module CommentsHelper
  def link_to_comment(comment, options = {})
    link_to_question comment.to_question, options.merge(anchor: "comment-#{comment.id}", deleted: comment.deleted?)
  end
end
