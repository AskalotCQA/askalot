class AnswersController < ApplicationController

  def index
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      flash[:notice] = "Je to tam"

      redirect_to question_path(@question)
    else
      flash_error_messages_for @question

      render :new
    end
  end

  def show
    @answers = Answer.find_all_by_question_id(params[:id])
  end

  private

  def answer_params
    params.require(:answer).permit(:text, :question_id).merge(author: current_user)
  end
end