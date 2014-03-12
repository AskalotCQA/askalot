class AnswersController < ApplicationController
  include Deleting
  include Voting

  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer   = Answer.new(answer_params)

    authorize! :answer, @question

    if @answer.save
      flash[:notice] = t('answer.create.success')
    else
      flash_error_messages_for @answer
    end

    redirect_to question_path(@question)
  end

  def update
    @answer   = Answer.find(params[:id])
    @question = @answer.question

    authorize! :edit, @answer

    @revision = AnswerRevision.create_revision!(current_user, @answer)

    if @answer.update_attributes(update_params) && @answer.update_attributes_by_revision(@revision)
      flash[:notice] = t 'answer.update.success'
    else
      @revision.destroy!

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

  def update_params
    params.require(:answer).permit(:text)
  end
end
