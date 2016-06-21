module Shared::Dashboard::Questions
  extend ActiveSupport::Concern

  def dashboard_questions(context)
    Shared::Question.in_context(context).where.not(author: current_user)
  end

  def dashboard_answers(context)
    Shared::Answer.in_context(context).where.not(author: current_user)
  end

  def dashboard_question_comments(questions)
    Shared::Comment.for('Shared::Question').where(commentable_id: questions.pluck(:id)).where.not(author: current_user)
  end

  def dashboard_answer_comments(answers)
    Shared::Comment.for('Shared::Answer').where(commentable_id: answers.pluck(:id)).where.not(author: current_user)
  end

  def dashboard_questions_watched(user)
    Shared::Question.in_context(categories_in_watched_contexts(user).pluck(:id)).where.not(author: current_user)
  end

  def dashboard_answers_watched(user)
    Shared::Answer.in_context(categories_in_watched_contexts(user).pluck(:id)).where.not(author: current_user)
  end

  def categories_in_watched_contexts(user)
    Shared::Category.all_in_contexts(user.watchings.of('Shared::Category').pluck(:watchable_id))
  end

  def questions_by_dashboard_param(from_dashboard, context, user)
    case from_dashboard
    when :new_questions
      questions = dashboard_questions(context)

      fresh(questions, user)
    when :new_answers
      context_answers = dashboard_answers(context)
      context_answers = fresh(context_answers, user)

      questions_by_answers(context_answers)
    when :new_comments
      context_questions = dashboard_questions(context)
      context_answers = dashboard_answers(context)

      context_questions_comments = fresh(dashboard_question_comments(context_questions), user)
      context_answers_comments = fresh(dashboard_answer_comments(context_answers), user)

      questions_by_comments(context_questions_comments, context_answers_comments)
    when :new_questions_in_watched_categories
      context_questions = dashboard_questions_watched(user)

      fresh(context_questions, user)
    when :new_answers_in_watched_categories
      context_answers = dashboard_answers_watched(user)
      context_answers = fresh(context_answers, user)

      questions_by_answers(context_answers)
    when :new_comments_in_watched_categories
      context_questions = dashboard_questions_watched(user)
      context_answers = dashboard_answers_watched(user)

      context_questions_comments = fresh(dashboard_question_comments(context_questions), user)
      context_answers_comments = fresh(dashboard_answer_comments(context_answers), user)

      questions_by_comments(context_questions_comments, context_answers_comments)
    end
  end

  def questions_by_answers(answers)
    Shared::Question.where(id: answers.pluck(:question_id))
  end

  def questions_by_comments(question_comments, answer_comments)
    answers = Shared::Answer.where(id: answer_comments.pluck(:commentable_id))

    Shared::Question.where(id: question_comments.pluck(:commentable_id) + answers.pluck(:question_id))
  end

  def fresh(query, user)
    query.where("#{query.table_name}.created_at >= ?", user.dashboard_last_sign_in_at)
  end
end
