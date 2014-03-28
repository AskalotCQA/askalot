class EvaluationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @evaluable = find_evaluable

    authorize! :evaluate, @evaluable

    @question   = @evaluable.to_question
    @evaluation = Evaluation.new(evaluation_params)

    if @evaluation.save
      process_markdown_for @evaluation do |user|
        dispatch_event :mention, @evaluation, for: user
      end

      dispatch_event :create, @evaluation, for: @question.watchers
      register_watching_for @question

      flash[:notice] = t('evaluation.create.success')
    else
      flash_error_messages_for @evaluation
    end

    redirect_to question_path(@question)
  end

  def update
    @evaluable = find_evaluable

    authorize! :evaluate, @evaluable

    @question   = @evaluable.to_question
    @evaluation = Evaluation.where(evaluable: @evaluable, evaluator: current_user).first

    if @evaluation.update_attributes(evaluation_params)
      dispatch_event :update, @evaluation, for: @question.watchers

      flash[:notice] = t 'evaluation.update.success'
    else
      flash_error_messages_for @evaluation
    end

    redirect_to question_path(@question)
  end

  private

  def find_evaluable
    [:question_id, :answer_id].each { |id| return id.to_s[0..-4].classify.constantize.find(params[id]) if params[id] }
  end

  def evaluation_params
    params.require(:evaluation).permit(:value, :text).merge(evaluable: @evaluable, evaluator: current_user)
  end
end
