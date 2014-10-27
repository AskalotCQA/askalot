class GroupsController < ApplicationController
  default_tab :all, only: :index

  before_action :authenticate_user!

  def create
    @group = Group.new(create_params)

    if @group.save
      flash[:notice] = t('group.create.success')

      redirect_to group_path(@group)
    else
      flash_error_messages_for @group

      redirect_to groups_path(tab: :all)
    end
  end

  def show
    @group     = Group.find(params[:id])
    @documents = @group.documents
    @question  = Question.new
    @labels  = @question.labels
    @answers = @question.ordered_answers
    @answer  = Answer.new(question: @question)
    @document= Document.new
    @questions = Question.recent

    @questions = @questions.page(params[:page]).per(20)
  end

  def index
    @groups = Group.all
  end

  private

  def create_params
    params.require(:group).permit(:title, :description, :visibility).merge(creator: current_user)
  end
end
