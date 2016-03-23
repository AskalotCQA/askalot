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

  def help
    authenticate_user!
  end

  def welcome
  end
end
end
