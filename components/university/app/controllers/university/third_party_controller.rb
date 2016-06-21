module University
  class ThirdPartyController < Shared::ApplicationController
    include Shared::Events::Dispatch

    layout 'university/simple'

    before_action :authenticate_user!

    after_action :allow_inline_frame

    def index
      @parent    = Shared::Category.find_by_third_party_hash! params[:hash]
      @category  = Shared::Category.find_or_create_by! name: params[:name], parent_id: @parent.id

      @question               = Shared::Question.new
      @question.category      = @category
      @question.question_type = Shared::QuestionType.questions.first

      @questions = @category.questions.order(touched_at: :desc)
      @questions = @questions.page(params[:page]).per(20)
    end

    def show
      @parent    = Shared::Category.find_by_third_party_hash! params[:hash]
      @category  = Shared::Category.find_by! name: params[:name], parent_id: @parent.id
      @question  = Shared::Question.find params[:id]

      authorize! :view, @question

      @labels  = @question.labels
      @answers = @question.ordered_reactions
      @answer  = Shared::Answer.new(question: @question)
      @view    = @question.views.create! viewer: current_user

      @question.increment :views_count

      dispatch_event :create, @view, for: @question.watchers

      render 'university/third_party/questions/show_forum' if @question.mode.forum?
      render 'university/third_party/questions/show' unless @question.mode.forum?
    end

    private

    def allow_inline_frame
      response.headers['X-Frame-Options'] = 'ALLOWALL'
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Request-Methods'] = '*'
      response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = 'X-CSRFToken'
    end
  end
end
