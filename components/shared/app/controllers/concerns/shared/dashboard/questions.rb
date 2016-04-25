module Shared::Dashboard::Questions
  extend ActiveSupport::Concern

  def dashboard_questions(context)
    Shared::Question.in_context(context)
  end

  def dashboard_answers(context)
    Shared::Answer.in_context(context)
  end

  def dashboard_question_comments(questions)
    Shared::Comment.for(:question).where("commentable_id IN (?)", questions.pluck(:id))
  end

  def dashboard_answer_comments(answers)
    Shared::Comment.for(:answer).where("commentable_id IN (?)", answers.pluck(:id))
  end

  def dashboard_questions_watched(questions, user)
    questions.joins(:watchings).where("watcher_id = ?", user.id)
  end

  def dashboard_answers_watched(answers, questions)
    answers.where("answers.question_id IN (?)", questions.pluck(:id))
  end

  def dashboard_question_comments_watched(questions)
    Shared::Comment.for(:question).where("commentable_id IN (?)", questions.pluck(:id))
  end

  def dashboard_answer_comments_watched(answers)
    Shared::Comment.for(:answer).where("commentable_id IN (?)", answers.pluck(:id))
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
      when :new_questions_in_watched_categories
        context_questions = dashboard_questions(context)
        context_questions = dashboard_questions_watched(context_questions, user)
        only_new(context_questions, user)
      when :new_answers_in_watched_categories
        context_questions = dashboard_questions(context)
        context_answers = dashboard_answers(context)
        context_questions = dashboard_questions_watched(context_questions, user)
        context_answers = dashboard_answers_watched(context_answers, context_questions)
        context_answers = only_new(context_answers, user)
        questions_by_answers(context_answers)
      else
        questions = dashboard_questions(context)
        only_new(questions, user)
    end
  end

  def questions_by_answers(answers)
    Shared::Question.joins(:answers).where(answers: {id: answers.pluck(:id) }).uniq
  end

  def only_new(query, user)
    query.where("#{query.table_name}.created_at >= ?", user.dashboard_last_sign_in_at)
  end
end
