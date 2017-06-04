module Shared
class StaticPagesController < ApplicationController
  skip_before_filter :login_required, only: :home if Rails.module.mooc? && Rails.env_type.test?

  def home
    count = 4

    @new     = Shared::Question.order(created_at: :desc).limit(count)
    @solved  = Shared::Question.solved.random.limit(count)
    @favored = Shared::Question.favored.random.limit(count)

    @question = Shared::Questions::ToAnswerRecommender.next

    @all_news = Shared::News.order('news.id DESC').active.limit(count)
  end

  def dashboard
    @question = Shared::Questions::ToAnswerRecommender.next
    @context_id = Shared::Context::Manager.current_context_id

    service = Shared::Dashboard::DashboardService

    context_questions         = service.dashboard_questions @context_id, current_user
    context_answers           = service.dashboard_answers @context_id, current_user
    context_question_comments = service.dashboard_question_comments context_questions, current_user
    context_answer_comments   = service.dashboard_answer_comments context_answers, current_user

    @new_questions = service.dashboard_count context_questions, current_user
    @new_answers   = service.dashboard_count context_answers, current_user
    @new_comments  = service.dashboard_count(context_question_comments, current_user) + service.dashboard_count(context_answer_comments, current_user)

    context_questions         = service.dashboard_questions_watched current_user
    context_answers           = service.dashboard_answers_watched current_user
    context_question_comments = service.dashboard_question_comments context_questions, current_user
    context_answer_comments   = service.dashboard_answer_comments context_answers, current_user

    @new_questions_watched = service.dashboard_count context_questions, current_user
    @new_answers_watched   = service.dashboard_count context_answers, current_user
    @new_comments_watched  = service.dashboard_count(context_question_comments, current_user) + service.dashboard_count(context_answer_comments, current_user)

    limit = 30

    @news = Shared::News.where('created_at >= ?', current_user.dashboard_last_sign_in_at).order('news.id DESC').active.limit(1).first

    @activities = Shared::Activity.includes(:resource, :initiator).in_context(@context_id).global.not_of(current_user)
                  .where(resource_type: [Shared::Answer, Shared::Comment, Shared::Evaluation, Shared::Question])
                  .where('activities.created_at >= ?', current_user.dashboard_last_sign_in_at)
                  .order('activities.id DESC')
                  .limit(limit)

    @followed_activities = Shared::Activities::ActivitiesFilter.activities_for_followed_categories(current_user).in_context(@context_id).not_of(current_user)
                  .where('activities.created_at >= ?', current_user.dashboard_last_sign_in_at)
                  .order('activities.id DESC')
                  .limit(limit)
  end

  def help
    authenticate_user!
  end

  def welcome
  end

  def welcome_without_confirmation
  end
end
end
