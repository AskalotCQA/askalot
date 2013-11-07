class QuestionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @questions = Question.order(:created_at).page(params[:page]).per(10)
  end

  def show
    # TODO
  end

  def new
    @question = Question.new
  end

  def edit
    # TODO
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      render 'show'
    else
      render 'new'
    end
  end

  def update
    # TODO
  end

  def destroy
    # TODO
  end

  private

  def question_params
    params.require(:question).permit(:title, :text, :tags)
  end
end
