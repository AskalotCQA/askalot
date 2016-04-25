module Shared::Dashboard::Questions
  extend ActiveSupport::Concern

  def dashboard_questions(context)
    Shared::Question.in_context(context)
  end

  def dashboard_answers(context)
    Shared::Answer.in_context(context)
  end

  def dashboard_question_comments
    Shared::Comment.for('Shared::Question')
  end

  def dashboard_answer_comments
    Shared::Comment.for('Shared::Answer')
  end

  def dashboard_questions_watched(user)
    Shared::Question.in_context(categories_in_watched_contexts(user).pluck(:id))
  end

  def dashboard_answers_watched(user)
    Shared::Answer.in_context(categories_in_watched_contexts(user).pluck(:id))
  end

  def dashboard_question_comments_watched(questions)
    Shared::Comment.for(:question).where("commentable_id IN (?)", questions.pluck(:id))
  end

  def dashboard_answer_comments_watched(answers)
    Shared::Comment.for(:answer).where("commentable_id IN (?)", answers.pluck(:id))
  end

  def categories_in_watched_contexts(user)
    Shared::Category.all_in_contexts(user.watchings.of('Shared::Category').pluck(:watchable_id))
  end

  def questions_by_dashboard_param(from_dashboard, context, user)
    case from_dashboard
      when :new_questions
        questions = dashboard_questions(context)

        only_new(questions, user)
      when :new_answers
        context_answers = dashboard_answers(context)
        context_answers = only_new(context_answers, user)

        questions_by_answers(context_answers)
      when :new_comments
        context_questions_comments = only_new(dashboard_question_comments, user)
        context_answers_comments = only_new(dashboard_answer_comments, user)

        questions_by_comments(context_questions_comments, context_answers_comments)
      when :new_questions_in_watched_categories
        context_questions = dashboard_questions_watched(user)

        only_new(context_questions, user)
      when :new_answers_in_watched_categories
        context_answers = dashboard_answers_watched(user)
        context_answers = only_new(context_answers, user)

        questions_by_answers(context_answers)
      else
        questions = dashboard_questions(context)

        only_new(questions, user)
    end
  end

  def questions_by_answers(answers)
    Shared::Question.where(id: answers.pluck(:question_id))
  end

  def questions_by_comments(question_comments, answer_comments)
    answers = Shared::Answer.where(id: answer_comments.pluck(:commentable_id))
    Shared::Question.where(id: question_comments.pluck(:commentable_id) + answers.pluck(:question_id))
  end

  def only_new(query, user)
    query.where("#{query.table_name}.created_at >= ?", user.dashboard_last_sign_in_at)
  end
end
