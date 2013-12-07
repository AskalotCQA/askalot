class QuestionsController < ApplicationController
  include Voting

  before_action :authenticate_user!
  before_action :set_default_tab, only: :index

  def index
    @questions = case params[:tab].to_sym
                 when :'questions-new'      then Question.order(created_at: :desc)
                 when :'questions-answered' then Question.answered.order(updated_at: :desc)
                 when :'questions-favored'  then Question.favored_by(current_user).order('favorites.created_at desc')
                 else fail
                 end

    @questions = @questions.page(params[:page]).per(10)
    @questions = @questions.tagged_with params[:tags] if params[:tags].present?
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

    @question.view_by! current_user
  end

  def favor
    @question = Question.find(params[:id])

    @question.toggle_favoring_by! current_user
  end

  private

  # TODO (smolnar) use concern
  def set_default_tab
    params[:tab] ||= :'questions-new'
  end

  def question_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list).merge(author: current_user)
  end
end
