module University
class EvaluationsController < ApplicationController
  include Editables::Update

  include Events::Dispatch
  include Markdown::Process
  include Watchings::Register

  before_action :authenticate_user!

  def create
    @evaluable = find_evaluable

    authorize! :evaluate, @evaluable

    @question   = @evaluable.to_question
    @evaluation = Evaluation.new(create_params)

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

    respond_to do |format|
      format.html { redirect_to question_path(@question) }
      format.js   { redirect_to question_path(@question), format: :js }
    end
  end

  private

  def find_evaluable
    [:question_id, :answer_id].each { |id| return id.to_s[0..-4].classify.constantize.find(params[id]) if params[id] }
  end

  def create_params
    params.require(:evaluation).permit(:value, :text).merge(evaluable: @evaluable, author: current_user)
  end

  def update_params
    params.require(:evaluation).permit(:value, :text)
  end
end
end
