module Shared
class StaticPagesController < ApplicationController
  skip_before_filter :login_required, only: :home

  def home
    count = 4

    @new     = Shared::Question.order(created_at: :desc).limit(count)
    @solved  = Shared::Question.solved.random.limit(count)
    @favored = Shared::Question.favored.random.limit(count)

    @question = Shared::Questions::ToAnswerRecommender.next
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
