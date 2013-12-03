class QuestionsController < ApplicationController
  before_filter :authenticate_user!
  include Voting

  def index
    @questions = Question.order('created_at desc').page(params[:page]).per(10)
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      flash[:notice] = t('question.create.success')

      redirect_to question_path(@question)
    else
      flash_error_messages_for @question

      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
    @author   = @question.author
    @labels   = @question.labels
    @answers  = @question.answers.order('created_at desc')

    @answer   = Answer.new question: @question
  end

  def favor
    @question = Question.find(params[:id])

    @question.toggle_favoring_by! current_user
  end

  private

  def question_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list).merge(author: current_user)
  end
end
