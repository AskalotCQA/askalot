class QuestionsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
    else
      render 'new'
    end
  end

  private

    def question_params
      params.require(:question).permit(:title, :text, :tags)
    end
end