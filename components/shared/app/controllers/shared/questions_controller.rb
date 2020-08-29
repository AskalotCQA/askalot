module Shared
class QuestionsController < ApplicationController
  include Shared::Closeables::Close
  include Shared::Deletables::Destroy
  include Shared::Editables::Update
  include Shared::Searchables::Search
  include Shared::Votables::Vote
  include Shared::Watchables::Watch

  include Shared::Events::Dispatch
  include Shared::Markdown::Process
  include Shared::Watchings::Register

  default_tab :newest,  only: :index
  default_tab :results, only: :search

  before_action :authenticate_user!

  def index
    if params[:category]
      @category   = Shared::Category.find(params[:category])
      @context_id = @category.id
      @list       = @category.lists.create! lister: current_user

      dispatch_event :create, @list, for: @category.watchers
    end

    @questions = Shared::Dashboard::DashboardService.questions_by_dashboard_param(params[:from_dashboard].to_sym, @context_id, current_user) if params[:from_dashboard]
    @questions = Shared::Question.in_context(@context_id) unless params[:from_dashboard]

    @questions_controls_scope = @questions
    @questions = case params[:tab].to_sym
                 when :active     then @questions.active
                 when :unanswered then @questions.unanswered.by_votes
                 when :answered   then @questions.answered_but_not_best.by_votes
                 when :solved     then @questions.solved.by_votes
                 when :favored    then @questions.favored.by_votes
                 else @questions.newest
                 end

    @questions = filter_questions(@questions)
    @questions = @questions.includes(:question_type)
    @questions = @questions.page(params[:page]).per(20)

    initialize_polling
  end

  def new
    @question = Shared::Question.new

    @question.document      = University::Document.find(params[:document_id]) if params[:document_id]
    @question.category      = Shared::Category.find(params[:category_id]) if params[:category_id]
    @question.category      = nil if @question.category && @question.category.children.any?
    @question.question_type = Shared::QuestionType.find(params[:question_type_id]) if params[:question_type_id]
    @question.question_type = Shared::QuestionType.questions.first unless params[:question_type_id]

    respond_to do |format|
      format.html { render :new }
      format.js { render template: "#{Rails.module.downcase}/questions/new" }
    end
  end

  def create
    if params[:slido]
      old_user      = current_user
      slido         = Shared::User.where(login: 'slido').first
      @current_user = slido
    end

    @question = Shared::Question.new(create_params)

    authorize! :ask, @question

    if params[:attachments]
      params[:attachments].each { |a| @question.attachments.new({file: a}.merge(author: current_user)) }
    end

    if @question.save
      process_markdown_for @question do |user|
        dispatch_event :mention, @question, for: user, anonymous: @question.anonymous
      end

      if params[:slido]
        @current_user = old_user
      end

      # TODO (zbell) refactor: do not compose watchers here
      dispatch_event :create, @question, for: @question.parent_watchers + @question.tags.map(&:watchers).flatten, anonymous: @question.anonymous
      register_watching_for @question

      flash[:notice] = t("question.#{@question.mode}.create.success")

      return render js: "window.location = '#{mooc.unit_question_url( unit_id: params[:question][:category_id], id: @question.id)}'" if params[:question][:unit_view]
      return render js: "window.location = '#{university.third_party_question_path(hash: @question.category.parent.third_party_hash, name: @question.category.name, id: @question.id)}'" if request.referrer.include? 'third_party'
      redirect_to shared.question_path(@question)
    else
      prefix = request.referrer.include?('third_party') ? '/third_party' : ''

      if params[:slido]
        @current_user = old_user
      end

      # TODO (filip jandura) refactor different types of rendering for mooc/university
      respond_to do |format|
        format.html { render :new }
        format.js { render template: "#{Rails.module.downcase}#{prefix}/questions/new" }
      end
    end
  end

  def show
    @question = Shared::Question.find(params[:id])

    authorize! :view, @question

    @labels  = @question.labels
    @answers = @question.ordered_reactions
    @answer  = Shared::Answer.new(question: @question)
    @view    = @question.views.create! viewer: current_user

    @question.increment :views_count

    dispatch_event :create, @view, for: @question.watchers

    render :show_forum if @question.mode.forum?
  end

  def favor
    @question = Shared::Question.find(params[:id])

    authorize! :favor, @question

    @favorite = @question.toggle_favoring_by! current_user

    @question.favorites.reload

    dispatch_event dispatch_event_action_for(@favorite), @favorite, for: @question.author
  end

  def suggest
    @questions = Shared::Question.search_by(search_params).results.limit(10).sort_by(&:created_at).reverse!

    render json: @questions, root: false
  end

  private

  helper_method :filter_questions

  def initialize_polling
    unless params[:poll]
      session[:poll] = Rails.env_type.development? ? false : true if session[:poll].nil?

      return @poll = params[:poll] = session[:poll]
    end

    @poll = session[:poll] = params[:poll] == 'true' ? true : false
  end

  def filter_questions(relation)
    relation = relation.tagged_with(params[:tags]) if params[:tags].present?

    relation
  end

  def create_params
    params.require(:question).permit(:title, :text, :category_id, :document_id, :tag_list, :anonymous, :question_type_id).merge(author: current_user)
  end

  def update_params
    params.require(:question).permit(:title, :text, :category_id, :tag_list, :anonymous, :question_type_id)
  end

  protected

  def destroy_callback(deletable)
    # TODO (filip jandura) move logic to mooc module
    return redirect_to mooc.unit_path(id: @deletable.category.id) if params[:unit_view]
    return redirect_to university.third_party_index_path(hash: @deletable.category.parent.third_party_hash, name: @deletable.category.name) if request.referrer.include? 'third_party'

    respond_to do |format|
      format.html { redirect_to shared.questions_path, format: :html }
      format.js   { redirect_to university.index_document_questions_path(@deletable.parent), format: :js }
    end
  end
end
end
