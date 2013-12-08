class QuestionsController < ApplicationController
  include Voting

  before_action :authenticate_user!
  before_action :set_default_tab, only: :index

  def index
    @questions = case index_params[:tab].to_sym
                 when :'questions-new'      then Question.order(created_at: :desc)
                 when :'questions-answered' then Question.answered.order(updated_at: :desc)
                 when :'questions-favored'  then Question.favored_by(current_user).order('favorites.created_at desc')
                 else fail
                 end

    @questions = @questions.page(index_params[:page]).per(10)
    @questions = @questions.tagged_with index_params[:tags] if index_params[:tags].present?
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

  helper_method :index_params

  def index_params
    params.permit(:tags, :tab, :page)
  end

  # TODO (smolnar) use concern
  def set_default_tab
    params[:tab] ||= :'questions-new'
  end

  def question_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list).merge(author: current_user)
  end
end
