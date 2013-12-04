class AnswersController < ApplicationController
  def index
    @answers = Answer.all
  end

  def create
    @question = Question.find params[:question_id]
    @author   = @question.author
    @labels   = @question.labels
    @answers  = @question.answers
    @answer   = Answer.new(answer_params)

    if @answer.save
      flash[:notice] = t('answer.create.success')

      redirect_to question_path(@question)
    else
      flash_error_messages_for @answer

      render 'questions/show'
    end
  end

  def label
    @answer   = Answer.find(params[:id])
    @answers  = [@answer]
    @question = @answer.question

    if params[:value].to_sym == :best
      @question.answers.where.not(id: @answer.id).all.each do |answer|
        labeling = answer.labelings.by(current_user).with(params[:value]).first

        if labeling
          @answers << answer
          labeling.delete
        end
      end
    end

    @answer.toggle_labeling_by! current_user, params[:value]
  end

  private

  def answer_params
    params.require(:answer).permit(:text).merge(question: @question, author: current_user)
  end
end
