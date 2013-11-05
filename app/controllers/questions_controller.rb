class QuestionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @questions = Question.order("updated_at").page(params[:page])
  end


end
