class StaticPagesController < ApplicationController
  def home
    count = 4

    @new     = Question.order(created_at: :desc).limit(count)
    @solved  = Question.solved.random.limit(count)
    @favored = Question.favored.random.limit(count)

    @question = Question.unanswered.random.first || Question.random.first
  end

  def help
  end

  def welcome
  end
end
