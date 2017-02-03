module Shared::CommentsHelper
  def link_to_comment(comment, options = {})
    link_to_resource comment, options.merge(anchor: "comment-#{comment.id}")
  end

  def comment_highlighted?(comment)
    return false if comment.anonymous?

    comment.author.assigned?(comment.to_question.category, :teacher) || comment.author.assigned?(comment.to_question.category, :teacher_assistant)
  end

  def comment_from_administrator?(comment)
    return false if comment.anonymous?

    comment.author.assigned?(comment.to_question.category, :administrator)
  end
end
