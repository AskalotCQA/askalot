class StaticPagesController < ApplicationController
  def home
    count = 4

    @new     = Question.order(created_at: :desc).limit(count)
    @solved  = Question.solved.random.limit(count)
    @favored = Question.favored.random.limit(count)

    @question = Questions::ToAnswerRecommender.next
  end

  def help
    authenticate_user!
  end

  def welcome
  end
end
