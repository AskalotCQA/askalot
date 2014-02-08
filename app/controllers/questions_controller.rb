class QuestionsController < ApplicationController
  include Voting
  include Tabbing

  # TODO (smolnar) enable for all
  before_action :authenticate_user!, except: [:index]

  default_tab :'questions-new', only: :index

  def index
    @questions = case params[:tab].to_sym
                 when :'questions-new'      then Question.order(created_at: :desc)
                 when :'questions-answered' then Question.answered.order(updated_at: :desc)
                 when :'questions-favored'  then Question.favored.order(updated_at: :desc)
                 else fail
                 end

    @questions = filter_questions(@questions)

    @questions = @questions.page(params[:page]).per(10)

    initialize_polling
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

    @answer = Answer.new(question: @question)

    @question.views.create! viewer: current_user
  end

  def favor
    @question = Question.find(params[:id])

    @question.toggle_favoring_by! current_user
  end

  private

  helper_method :filter_questions

  def initialize_polling
    params[:poll] ||= true
  end

  def filter_questions(relation)
    return relation unless params[:tags].present?

    relation.tagged_with(params[:tags])
  end

  def question_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list).merge(author: current_user)
  end
end
