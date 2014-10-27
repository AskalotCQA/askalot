class Administration::ChangelogsController < Administration::DashboardController
  authorize_resource

  def create
    @changelog = Changelog.new(changelog_params)

    if @changelog.save
      form_message :notice, t('changelog.create.success'), key: params[:tab]

      redirect_to administration_root_path(tab: params[:tab])
    else
      form_error_messages_for @changelog, flash: flash.now, key: params[:tab]

      render_dashboard
    end
  end

  def update
    @changelog = Changelog.find(params[:id])

    if @changelog.update_attributes(changelog_params)
      form_message :notice, t('changelog.update.success'), key: params[:tab]
    else
      form_error_messages_for @changelog, key: params[:tab]
    end

    redirect_to administration_root_path(tab: params[:tab])
  end

  def destroy
    @changelog = Changelog.find(params[:id])

    if @changelog.destroy
      form_message :notice, t('changelog.delete.success'), key: params[:tab]
    else
      form_error_message t('changelog.delete.failure'), key: params[:tab]
    end

    redirect_to administration_root_path(tab: params[:tab])
  end

  private

  def changelog_params
    params.require(:changelog).permit(:version, :title, :text)
  end
end
