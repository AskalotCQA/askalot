class AnswersController < ApplicationController

  def index
    @answers = Answer.all
  end

  def create
    @question = Question.find params[:question_id]
    @author   = @question.author
    @answer   = @question.answers.build(answer_params)

    if @answer.save
      flash[:notice] = t('answer.create.success')

      redirect_to question_path(@question)
    else
      flash_error_messages_for @answer

      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:text).merge(author: current_user)
  end
end
