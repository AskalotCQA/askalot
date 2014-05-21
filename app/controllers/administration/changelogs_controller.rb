class Administration::ChangelogsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize! :administrate, nil

    @changelog = Changelog.new(changelog_params)

    if @changelog.save
      flash[:notice] = t('changelog.create.success')
    else
      form_error_messages_for @changelog
    end

    redirect_to administration_dashboard_index_path(tab: params[:tab]  )
  end

  def update
    authorize! :administrate, nil

    @changelog = Changelog.find(params[:id])

    if @changelog.update_attributes(changelog_params)
      flash[:notice] = t('changelog.update.success')
    else
      form_error_messages_for @changelog
    end

    redirect_to administration_dashboard_index_path(tab: params[:tab]  )
  end

  private

  def changelog_params
    params.require(:changelog).permit(:version, :title, :text  )
  end
end
