module Shared::Dashboard::Questions
  extend ActiveSupport::Concern

  def new_questions(context)
    Shared::Question.in_context(context)
  end

  def new_answers(context)
    Shared::Answer.in_context(context)
  end

  def new_question_comments(questions)
    Shared::Comment.for(:question).where("commentable_id IN (?)", questions.pluck(:id))
  end

  def new_answer_comments(answers)
    Shared::Comment.for(:answer).where("commentable_id IN (?)", answers.pluck(:id))
  end

  def new_questions_watched(questions, user)
    questions.joins(:watchings).where("watcher_id = ?", user.id)
  end

  def new_answers_watched(answers, questions)
    answers.where("answers.question_id IN (?)", questions.pluck(:id))
  end

  def new_question_comments_watched(questions)
    Shared::Comment.for(:question).where("commentable_id IN (?)", questions.pluck(:id))
  end

  def new_answer_comments_watched(answers)
    Shared::Comment.for(:answer).where("commentable_id IN (?)", answers.pluck(:id))
  end

  def questions_by_dashboard_param(from_dashboard, context, user)
    case from_dashboard
      when :new_questions
        new_questions(context)
      when :new_answers
        context_answers = new_answers(context)
        questions_by_answers(context_answers)
      when :new_questions_in_watched_categories
        context_questions = new_questions(context)
        new_questions_watched(context_questions, user)
      when :new_answers_in_watched_categories
        context_questions = new_questions(context)
        context_answers = new_answers(context)
        context_questions = new_questions_watched(context_questions, user)
        context_answers = new_answers_watched(context_answers, context_questions)
        questions_by_answers(context_answers)
      else
        new_questions(context)
    end
  end

  def questions_by_answers(answers)
    Shared::Question.joins(:answers).where(answers: {id: answers.pluck(:id) })
  end
end
