module Shared
class StaticPagesController < ApplicationController
  skip_before_filter :login_required, only: :home

  def home
    count = 4

    @new     = Shared::Question.order(created_at: :desc).limit(count)
    @solved  = Shared::Question.solved.random.limit(count)
    @favored = Shared::Question.favored.random.limit(count)

    @question = Shared::Questions::ToAnswerRecommender.next

    @news = Shared::New.order('news.id DESC').active.limit(count)
  end

  def dashboard
    @question = Shared::Questions::ToAnswerRecommender.next

    context_questions = Shared::Question.in_context(Shared::Context::Manager.current_context)
    context_answers = Shared::Answer.in_context(Shared::Context::Manager.current_context)
    context_question_comments = Shared::Comment.for(:question).where("commentable_id IN (?)", context_questions.pluck(:id))
    context_question_answers = Shared::Comment.for(:answer).where("commentable_id IN (?)", context_answers.pluck(:id))

    @new_questions = dashboard_count context_questions
    @new_answers = dashboard_count context_answers
    @new_comments = dashboard_count(context_question_comments) + dashboard_count(context_question_answers)

    context_questions = context_questions.joins(:watchings).where("watcher_id = ?", current_user.id)
    context_answers = context_answers.where("answers.question_id IN (?)", context_questions.pluck(:id))
    context_question_comments = Shared::Comment.for(:question).where("commentable_id IN (?)", context_questions.pluck(:id))
    context_question_answers = Shared::Comment.for(:answer).where("commentable_id IN (?)", context_answers.pluck(:id))

    @new_questions_watched = dashboard_count context_questions
    @new_answers_watched = dashboard_count context_answers
    @new_comments_watched = dashboard_count(context_question_comments) + dashboard_count(context_question_answers)

    limit = 50

    @news = Shared::New.order('news.id DESC').active.limit(limit)
    @activities = Shared::Activity.in_context(Shared::Context::Manager.current_context).where("activities.created_at >= ?", current_user.current_sign_in_at).order('activities.id DESC').limit(limit)
  end

  def help
    authenticate_user!
  end

  def welcome
  end

  def welcome_without_confirmation
  end

  private

  def dashboard_count(query)
    query.where("#{query.table_name}.created_at >= ?", current_user.last_sign_in_at).count
  end
end
end
