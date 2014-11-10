class GroupsController < ApplicationController
  include Deletables::Destroy
  include Editables::Update

  include Events::Dispatch
  include Markdown::Process

  default_tab :all, only: :index

  before_action :authenticate_user!

  load_and_authorize_resource

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
  end

  def index
    @groups = Group.accessible_by(current_ability)
  end

  private

  def create_params
    params.require(:group).permit(:title, :description, :visibility).merge(creator: current_user)
  end

  def update_params
    params.require(:group).permit(:title, :description, :visibility)
  end
end
