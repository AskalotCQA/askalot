class StaticPagesController < ApplicationController
  def home
    @new      = Question.order(created_at: :desc).limit(5)
    @answered = Question.answered.order(updated_at: :desc).limit(5)
    @favored  = Question.favored.order(created_at: :desc).limit(5)
  end
end
