class Documents::QuestionsController < ApplicationController
  include Deletables::Destroy
  include Editables::Update
  include Votables::Vote
  include Watchables::Watch

  include Events::Dispatch
  include Markdown::Process
  include Watchings::Register

  before_action :authenticate_user!

  def index
    @document  = Document.find(params[:document_id])
    @questions = @document.questions

    @questions = @questions.page(params[:page]).per(20)
  end

  def new
    @question = Question.new
    @document = Document.find(params[:document_id])
    @group    = Group.find(params[:group_id])
  end

  def create
    @question = Question.new(create_params)
    @document = Document.find(params[:document_id])

    authorize! :ask, @question

    if @question.save
      process_markdown_for @question do |user|
        dispatch_event :mention, @question, for: user
      end

      dispatch_event :create, @question, for: @question.tags.map(&:watchers).flatten, anonymous: @question.anonymous
      register_watching_for @question

      flash[:notice] = t('question.create.success')
    else
      flash_error_messages_for @question
    end

    redirect_to documents_questions_path(document_id: params[:document_id])
  end

  def show
    @question = Question.find(params[:id])
    @document = Document.find(params[:document_id])
    @group    = @document.group

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
    params.require(:question).permit(:title, :text, :tag_list, :anonymous).merge(author: current_user)
    .merge(document: Document.find(params[:document_id]))
  end

  def update_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list)
  end
end
