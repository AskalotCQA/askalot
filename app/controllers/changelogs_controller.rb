class ChangelogsController < ApplicationController

  def index
    @changelogs = Changelog.order(version: :desc)
  end

  def new
    @changelog = Changelog.new
  end

  def create
    @changelog = Changelog.new(changelog_params)
    if @changelog.save
      redirect_to changelogs_path
    else
      redirect_to admin_dashboard_index_path(tab: params[:tab])
    end
  end

  def changelog_params
    params.require(:changelog).permit(:version, :title, :text)
  end

  def edit
    @changelog = Changelog.find(params[:id])
  end

  def update
    @changelog = Changelog.find(params[:id])
    if @changelog.update_attributes(changelog_params)
      redirect_to admin_dashboard_index_path(tab: params[:tab])
    else

    end
  end

end
