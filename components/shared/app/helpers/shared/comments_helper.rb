module Shared::CommentsHelper
  def link_to_comment(comment, options = {})
    link_to_resource comment, options.merge(anchor: "comment-#{comment.id}")
  end

  def comment_highlighted?(comment)
    comment.author.assigned?(comment.to_question.category, :teacher) || comment.author.assigned?(comment.to_question.category, :teacher_assistant)
  end
end
