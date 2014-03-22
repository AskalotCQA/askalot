class QuestionsController < ApplicationController
  include Deleting
  include Editing
  include Markdown
  include Voting
  include Tabbing

  include Notifications::Notifying
  include Notifications::Watching

  include Watchings::Watching

  default_tab :recent, only: :index

  before_action :authenticate_user!

  def index
    @questions = case params[:tab].to_sym
                 when :unanswered then Question.unanswered.order('questions.votes_lb_wsci_bp desc, questions.created_at desc')
                 when :answered   then Question.answered.by_votes.order(created_at: :desc)
                 when :solved     then Question.solved.by_votes.order(created_at: :desc)
                 when :favored    then Question.favored.by_votes.order(created_at: :desc)
                 else Question.recent
                 end

    @questions = filter_questions(@questions)
    @questions = @questions.page(params[:page]).per(20)

    initialize_polling
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)

    authorize! :ask, @question

    if @question.save
      process_markdown_for @question do |user|
        notify_about :mention, @question, for: user
      end

      #TODO(zbell) do not notify about anonymous questions since user.nick is still exposed in notifications
      notify_about :create, @question, for: @question.category.watchers + @question.tags.map(&:watchers).flatten unless @question.anonymous
      register_watching_for @question

      flash[:notice] = t('question.create.success')

      redirect_to question_path(@question)
    else
      @category = Category.find_by(id: params[:question][:category_id]) if params[:question]

      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
    @labels   = @question.labels
    @answers  = @question.ordered_answers

    @answer = Answer.new(question: @question)

    authorize! :view, @question

    @view = @question.views.create! viewer: current_user

    @question.increment :views_count

    notify_about :create, @view, for: @question.watchers
  end

  def favor
    @question = Question.find(params[:id])

    authorize! :favor, @question

    @favorite = @question.toggle_favoring_by! current_user

    @question.favorites.reload

    notify_about notify_action_for(@favorite), @favorite, for: @question.watchers
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

  def update_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list)
  end
end
