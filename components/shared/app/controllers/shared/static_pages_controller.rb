module Shared
class StaticPagesController < ApplicationController
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
end
end
