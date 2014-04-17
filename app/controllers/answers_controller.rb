class AnswersController < ApplicationController
  include Deletables::Destroy
  include Editables::Update
  include Votables::Vote

  include Events::Dispatch
  include Markdown::Process
  include Watchings::Register

  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer   = Answer.new(answer_params)

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

    redirect_to question_path(@question, anchor: @answer.id ? nil : :answer)
  end

  def label
    @answer   = Answer.find(params[:id])
    @answers  = [@answer]
    @question = @answer.question

    case params[:value].to_sym
      when :best
        authorize! :label, @question

        @question.answers.where.not(id: @answer.id).each do |answer|
          labeling = answer.labelings.by(current_user).with(:best).first

          if labeling
            @answers << answer
            labeling.mark_as_deleted_by! current_user

            dispatch_event :delete, labeling, for: answer.question.watchers
          end
        end
      when :helpful
        authorize! :label, @question

        fail if @answer.labelings.by(current_user).with(:best).exists?
      else
        fail
    end

    @labeling = @answer.toggle_labeling_by! current_user, params[:value]

    dispatch_event dispatch_event_action_for(@labeling), @labeling, for: @question.watchers
  end

  private

  def answer_params
    params.require(:answer).permit(:text).merge(question: @question, author: current_user)
  end

  def update_params
    params.require(:answer).permit(:text)
  end
end
