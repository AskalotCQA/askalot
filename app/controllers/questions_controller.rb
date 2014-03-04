class QuestionsController < ApplicationController
  include Voting
  include Tabbing

  before_action :authenticate_user!

  default_tab :'questions-new', only: :index

  def index
    @questions = case params[:tab].to_sym
                 when :'questions-new'        then Question.order(touched_at: :desc)
                 when :'questions-unanswered' then Question.unanswered.order('questions.votes_lb_wsci_bp desc, questions.created_at desc')
                 when :'questions-answered'   then Question.answered.by_votes.order(created_at: :desc)
                 when :'questions-solved'     then Question.solved.by_votes.order(created_at: :desc)
                 when :'questions-favored'    then Question.favored.by_votes.order(created_at: :desc)
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

    authorize! :ask, @question

    if @question.save
      flash[:notice] = t('question.create.success')

      redirect_to question_path(@question)
    else
      flash_error_messages_for @question, flash: flash.now

      @category = Category.find_by(id: params[:question][:category_id]) if params[:question]

      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
    @author   = @question.author
    @labels   = @question.labels
    @answers  = @question.answers_ordered

    @answer = Answer.new(question: @question)

    @question.views.create! viewer: current_user
    @question.views.reload
  end

  def favor
    @question = Question.find(params[:id])

    @question.toggle_favoring_by! current_user
    @question.favorites.reload
  end

  def suggest
    @questions = Question.where('id = ? or title like ?', params[:q].to_i, "#{params[:q]}%")

    render json: @questions, root: false
  end

  private

  helper_method :filter_questions

  def initialize_polling
    unless params[:poll]
      session[:poll] = Rails.env.development? ? false : true if session[:poll].nil?

      return @poll = params[:poll] = session[:poll]
    end

    @poll = session[:poll] = params[:poll] == 'true' ? true : false
  end

  def filter_questions(relation)
    return relation unless params[:tags].present?

    relation.tagged_with(params[:tags])
  end

  def question_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list, :anonymous).merge(author: current_user)
  end
end
