module Shared
class AnswersController < ApplicationController
  include Shared::Deletables::Destroy
  include Shared::Editables::Update
  include Shared::Votables::Vote

  include Shared::Events::Dispatch
  include Shared::Markdown::Process
  include Shared::Watchings::Register

  before_action :authenticate_user!

  def create
    @question = Shared::Question.find(params[:question_id])
    @answer   = Shared::Answer.new(create_params)

    authorize! :answer, @question

    if @answer.save
      process_markdown_for @answer do |user|
        dispatch_event :mention, @answer, for: user
      end

      dispatch_event :create, @answer, for: @question.watchers
      register_watching_for @question

      flash[:notice] = t("answer.#{@question.mode}.create.success")
    else
      form_error_messages_for @answer
    end

    # TODO (filip jandura) move logic to mooc module
    return redirect_to mooc.unit_question_path(unit_id: @question.category.id, id: @question.id) if params[:unit_view]
    return redirect_to university.third_party_question_path(hash: @question.category.parent.third_party_hash, name: @question.category.name, id: @question.id) if request.referrer.include? 'third_party'

    respond_to do |format|
      format.html { redirect_to question_path(@question, anchor: @answer.id ? nil : :answer), format: :html }
      format.js   { redirect_to question_path(@question, anchor: @answer.id ? nil : :answer), format: :js }
    end
  end

  def label
    @answer   = Shared::Answer.find(params[:id])
    @answers  = [@answer]
    @question = @answer.question

    anonymous = @question.anonymous && @question.author == current_user

    case params[:value].to_sym
    when :best
      authorize! :label, @question

      @question.answers.where.not(id: @answer.id).each do |answer|
        labeling = answer.labelings.by(current_user).with(:best).first

        if labeling
          @answers << answer
          labeling.mark_as_deleted_by! current_user

          dispatch_event :delete, labeling, for: answer.question.watchers, anonymous: anonymous
        end
      end

      @question.update(with_best_answer: false)
    when :helpful
      authorize! :label, @question

      fail if @answer.labelings.by(current_user).with(:best).exists?
    else
      fail
    end

    @labeling = @answer.toggle_labeling_by! current_user, params[:value]

    @question.update(with_best_answer: true) if @answer.labels.where(value: 'best').first

    dispatch_event dispatch_event_action_for(@labeling), @labeling, for: @question.watchers, anonymous: anonymous
  end

  private

  def create_params
    params.require(:answer).permit(:text).merge(question: @question, author: current_user)
  end

  def update_params
    params.require(:answer).permit(:text)
  end

  protected

  def destroy_callback(deletable)
    respond_to do |format|
      format.html { redirect_to :back, format: :html }
      format.js   { redirect_to question_path(@deletable.to_question), format: :js }
    end
  end
end
end
