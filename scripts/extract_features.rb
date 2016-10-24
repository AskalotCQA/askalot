module ExtractFeatures
  extend self

  # Common features


  def is_student(user)
    user.assignments.count == 0 && user.role == :student
  end

  def portion_of_seen_categories(resource, category, user)
    user.lists.where(category: category.leaves).where('created_at > ?', resource.created_at)
        .select('DISTINCT(category_id)').count / category.leaves.count.to_f
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
