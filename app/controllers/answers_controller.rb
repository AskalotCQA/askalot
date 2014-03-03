class AnswersController < ApplicationController
  include Markdown
  include Notifications::Watching
  include Notifications::Notifying
  include Voting

  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer   = Answer.new(answer_params)

    authorize! :answer, @question

    process_markdown_for @answer do |user|
      notify_about :'mention-user', @answer, for: user
    end

    if @answer.save
      flash[:notice] = t('answer.create.success')

      notify_about :'add-answer', @answer, for: @question.watchers

      register_watching_for @answer
    else
      flash_error_messages_for @answer
    end

    redirect_to question_path(@question)
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
          labeling.delete
        end
      end
    when :helpful
      authorize! :label, @question

      fail if @answer.labelings.by(current_user).with(:best).exists?
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
