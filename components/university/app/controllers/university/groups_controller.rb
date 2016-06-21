module University
class GroupsController < Shared::ApplicationController
  include Shared::Deletables::Destroy
  include Shared::Editables::Update

  include Shared::Events::Dispatch
  include Shared::Markdown::Process

  include Shared::MarkdownHelper

  default_tab :all, only: :index

  before_action :authenticate_user!
  before_action :determine_groups_enabled

  def create
    @group = University::Group.new(create_params)

    if @group.save
      flash[:notice] = t('group.create.success')

      redirect_to group_path(@group)
    else
      flash_error_messages_for @group

      redirect_to groups_path(tab: :all)
    end
  end

  def show
    @group     = University::Group.find(params[:id])
    @documents = @group.documents.order(created_at: :desc).page(params[:page]).per(20)

    authorize! :show, @group
  end

  def index
    authorize! :index, University::Group

    @groups = University::Group.accessible_by(current_ability)
    @groups = @groups.page(params[:page]).per(20)
  end

  private

  def create_params
    params.require(:group).permit(:title, :description, :visibility).merge(creator: current_user)
  end

  def update_params
    params.require(:group).permit(:title, :description, :visibility)
  end

  protected

  def destroy_callback(deletable)
    redirect_to groups_path
  end

  def determine_groups_enabled
    redirect_to shared.root_path unless Shared::Configuration.enable.groups?
  end
end
end
