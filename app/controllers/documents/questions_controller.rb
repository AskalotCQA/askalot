class Groups::QuestionsController < ApplicationController
  include Deletables::Destroy
  include Editables::Update
  include Votables::Vote
  include Watchables::Watch

  include Events::Dispatch
  include Markdown::Process
  include Watchings::Register

  before_action :authenticate_user!

  def index
    @questions = case params[:tab].to_sym
                   when :unanswered then Question.unanswered.by_votes
                   when :answered   then Question.answered_but_not_best.by_votes
                   when :solved     then Question.solved.by_votes
                   when :favored    then Question.favored.by_votes
                   else Question.recent
                 end

    @questions = @questions.page(params[:page]).per(20)
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(create_params)

    authorize! :ask, @question

    if @question.save
      process_markdown_for @question do |user|
        dispatch_event :mention, @question, for: user
      end

      dispatch_event :create, @question, for: @question.category.watchers + @question.tags.map(&:watchers).flatten, anonymous: @question.anonymous
      register_watching_for @question

      flash[:notice] = t('question.create.success')

      # TODO Change link
      redirect_to question_path(@question)
    else
      @category = Category.find_by(id: params[:question][:category_id]) if params[:question]

      # TODO Change link
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])

    authorize! :view, @question

    @labels  = @question.labels
    @answers = @question.ordered_answers
    @answer  = Answer.new(question: @question)
    @view    = @question.views.create! viewer: current_user

    @question.increment :views_count

    dispatch_event :create, @view, for: @question.watchers
  end

  def favor
    @question = Question.find(params[:id])

    authorize! :favor, @question

    @favorite = @question.toggle_favoring_by! current_user

    @question.favorites.reload

    dispatch_event dispatch_event_action_for(@favorite), @favorite, for: @question.watchers
  end

  def suggest
    @questions = Question.where('id = ? or title like ?', params[:q].to_i, "#{params[:q]}%")

    render json: @questions, root: false
  end

  private
  def create_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list, :anonymous).merge(author: current_user)
  end

  def update_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list)
  end
end
