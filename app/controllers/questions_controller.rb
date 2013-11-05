class QuestionsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @question = Question.find(params[:id])
  end

end