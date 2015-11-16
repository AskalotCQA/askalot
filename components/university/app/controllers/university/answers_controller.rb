module University
class AnswersController < ApplicationController
  include University::Deletables::Destroy
  include University::Editables::Update
  include University::Votables::Vote

  include University::Events::Dispatch
  include University::Markdown::Process
  include University::Watchings::Register

  before_action :authenticate_user!

  def create
    @question = University::Question.find(params[:question_id])
    @answer   = University::Answer.new(create_params)

    authorize! :answer, @question

    if @answer.save
      process_markdown_for @answer do |user|
        dispatch_event :mention, @answer, for: user
      end

      dispatch_event :create, @answer, for: @question.watchers
      register_watching_for @question

      flash[:notice] = t('answer.create.success')
    else
      form_error_messages_for @answer
    end

    respond_to do |format|
      format.html { redirect_to question_path(@question, anchor: @answer.id ? nil : :answer), format: :html }
      format.js   { redirect_to question_path(@question, anchor: @answer.id ? nil : :answer), format: :js }
    end
  end

  def label
    @answer   = University::Answer.find(params[:id])
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
    when :helpful
      authorize! :label, @question

      fail if @answer.labelings.by(current_user).with(:best).exists?
    else
      fail
    end

    @labeling = @answer.toggle_labeling_by! current_user, params[:value]

    dispatch_event dispatch_event_action_for(@labeling), @labeling, for: @question.watchers, anonymous: anonymous
  end

  private

  def create_params
    params.require(:answer).permit(:text).merge(question: @question, author: current_user)
  end

  def update_params
    params.require(:answer).permit(:text)
  end
end
end
