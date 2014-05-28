class Administration::ChangelogsController < AdministrationController
  authorize_resource

  def destroy
    Changelog.find(params[:id]).destroy
    flash[:notice] = t('changelog.delete.success')

    redirect_to administration_root_path(tab: params[:tab])
  end

  def create
    @changelog = Changelog.new(changelog_params)

    if @changelog.save
      flash[:notice] = t('changelog.create.success')
    else
      form_error_messages_for @changelog
    end

    redirect_to administration_root_path(tab: params[:tab])
  end

  def update
    @changelog = Changelog.find(params[:id])

    if @changelog.update_attributes(changelog_params)
      flash[:notice] = t('changelog.update.success')
    else
      form_error_messages_for @changelog
    end

    redirect_to administration_root_path(tab: params[:tab])
  end

  private

  def changelog_params
    params.require(:changelog).permit(:version, :title, :text)
  end
end
