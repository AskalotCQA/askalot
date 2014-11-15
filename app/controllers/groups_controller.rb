class GroupsController < ApplicationController
  include Deletables::Destroy
  include Editables::Update

  include Events::Dispatch
  include Markdown::Process

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
    @documents = @group.documents.page(params[:page]).per(20)

    authorize! :show, @group
  end

  def index
    authorize! :index, Group

    @groups = Group.accessible_by(current_ability)
    @groups = @groups.page(params[:page]).per(20)
  end

  private

  def create_params
    params.require(:group).permit(:title, :description, :visibility).merge(creator: current_user)
  end

  def update_params
    params.require(:group).permit(:title, :description, :visibility)
  end
end
