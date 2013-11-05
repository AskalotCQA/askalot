class QuestionsController < ApplicationController
  before_filter :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :question_not_found

  def show
    @question = Question.find(params[:id])
  end

  def question_not_found

  end
end