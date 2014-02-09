class EvaluationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @evaluable = find_evaluable

    @question = @evaluable.is_a?(Question) ? @evaluable : @evaluable.question
    @author   = @question.author
    @labels   = @question.labels
    @answers  = @question.answers

    @answer     = Answer.new(question: @question)
    @evaluation = Evaluation.new(evaluation_params)

    if @evaluation.save
      flash[:notice] = t('evaluation.create.success')

      redirect_to question_path(@question)
    else
      flash_error_messages_for @evaluation

      render 'questions/show'
    end
  end

  private

  def find_evaluable
    [:question_id, :answer_id].each { |id| return id.to_s[0..-4].classify.constantize.find(params[id]) if params[id] }
  end

  def evaluation_params
    params.require(:evaluation).permit(:value, :text).merge(evaluable: @evaluable, evaluator: current_user)
  end
end
