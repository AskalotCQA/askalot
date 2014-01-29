class AnswersController < ApplicationController
  include Voting

  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @author   = @question.author
    @labels   = @question.labels
    @answers  = @question.answers

    @answer = Answer.new(answer_params)

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

    case params[:value].to_sym
    when :best
      authorize! :edit, @question

      @question.answers.where.not(id: @answer.id).each do |answer|
        labeling = answer.labelings.by(current_user).with(:best).first

        if labeling
          @answers << answer
          labeling.delete
        end
      end
    when :helpful
      authorize! :edit, @question

      fail if @answer.labelings.by(current_user).with(:best).exists?
    when :verified
      authorize! :verify, @answer
    else
      fail
    end

    @answer.toggle_labeling_by! current_user, params[:value]
  end

  private

  def answer_params
    params.require(:answer).permit(:text).merge(question: @question, author: current_user)
  end
end
