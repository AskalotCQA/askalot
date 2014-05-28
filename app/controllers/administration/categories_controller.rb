class Administration::CategoriesController < AdministrationController
  authorize_resource

  def create
    @category = Category.new(category_params)

    if @category.save
      form_message :notice, t('category.create.success'), key: params[:tab]
    else
      form_error_messages_for @category, key: params[:tab]
    end

    redirect_to administration_root_path(tab: params[:tab])
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

  private

  def category_params
    params.require(:category).permit(:name, :tags)
  end
end
