module Shared
class StaticPagesController < ApplicationController
  include Shared::Dashboard::Questions

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
    @context = Shared::Context::Manager.current_context

    context_questions = dashboard_questions @context
    context_answers = dashboard_answers @context
    context_question_comments = dashboard_question_comments context_questions
    context_question_answers = dashboard_answer_comments context_answers

    @new_questions = dashboard_count context_questions
    @new_answers = dashboard_count context_answers
    @new_comments = dashboard_count(context_question_comments) + dashboard_count(context_question_answers)

    context_questions = dashboard_questions_watched current_user
    context_answers = dashboard_answers_watched current_user
    context_question_comments = dashboard_question_comments context_questions
    context_question_answers = dashboard_answer_comments context_answers

    @new_questions_watched = dashboard_count context_questions
    @new_answers_watched = dashboard_count context_answers
    @new_comments_watched = dashboard_count(context_question_comments) + dashboard_count(context_question_answers)

    limit = 20

    @news = Shared::New.order('news.id DESC').active.limit(limit)
    @activities = Shared::Activity.in_context(@context).where("activities.created_at >= ?", current_user.dashboard_last_sign_in_at).order('activities.id DESC').limit(limit)
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
    fresh(query, current_user).count
  end
end
end
