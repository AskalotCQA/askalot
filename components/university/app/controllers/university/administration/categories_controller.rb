module University
class Administration::CategoriesController < Administration::DashboardController
  authorize_resource

  def create
    @category = Category.new(category_params)

    if @category.save
      form_message :notice, t('category.create.success'), key: params[:tab]

      redirect_to administration_root_path(tab: params[:tab])
    else
      form_error_messages_for @category, flash: flash.now, key: params[:tab]

      render_dashboard
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(category_params)
      form_message :notice, t('category.update.success'), key: params[:tab]
    else
      form_error_messages_for @category, key: params[:tab]
    end

    redirect_to administration_root_path(tab: params[:tab])
  end

  # TODO(zbell) add destroy?

  private

  def category_params
    params.require(:category).permit(:name, :tags)
  end
end
end
