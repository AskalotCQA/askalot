module Recommendation
  extend self

  # Helpers
  def is_student(user)
    user.assignments.count == 0 && user.role == :student
  end

  def user_answers_older_than_resource(resource, user)
    user.answers.older(resource.created_at)
  end

  def user_questions_older_than_resource(resource, user)
    user.questions.older(resource.created_at)
  end

  def user_comments_older_than_resource(resource, user)
    user.comments.where('created_at > ?', resource.created_at)
  end


end
