class AnswersController < ApplicationController
  include Deleting
  include Editing
  include Markdown
  include Voting

  include Notifications::Notifying
  include Notifications::Watching

  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer   = Answer.new(answer_params)

    authorize! :answer, @question

    if @answer.save
      process_markdown_for @answer do |user|
        notify_about :mention, @answer, for: user
      end

      notify_about :create, @answer, for: @question.watchers
      register_watching_for @answer

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
            labeling.destroy

            notify_about :delete, labeling, for: answer.watchers
          end
        end
      when :helpful
        authorize! :label, @question

        fail if @answer.labelings.by(current_user).with(:best).exists?
      else
        fail
    end

    @labeling = @answer.toggle_labeling_by! current_user, params[:value]

    notify_about notify_action_for(@labeling), @labeling, for: @answer.watchers
  end

  private

  def answer_params
    params.require(:answer).permit(:text).merge(question: @question, author: current_user)
  end

  def update_params
    params.require(:answer).permit(:text)
  end
end
