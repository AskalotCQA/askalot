class ChangelogsController < ApplicationController

  def index
    @changelogs = Changelog.all.sort
  end

  def create
    @changelog = Changelog.new(changelog_params)
    if @changelog.save
      flash[:notice] = t('changelog.create.success')
      redirect_to changelogs_path
    else
      form_error_messages_for @changelog
      redirect_to administration_dashboard_index_path(tab: params[:tab])
    end
  end

  def changelog_params
    params.require(:changelog).permit(:version, :title, :text)
  end

  def update
    @changelog = Changelog.find(params[:id])
    if @changelog.update_attributes(changelog_params)
      flash[:notice] = t('changelog.update.success')
      redirect_to administration_dashboard_index_path(tab: params[:tab])
    else
      form_error_messages_for @changelog
      redirect_to administration_dashboard_index_path(tab: params[:tab])
    end
  end
end
