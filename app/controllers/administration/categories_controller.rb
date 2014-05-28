class Administration::CategoriesController < AdministrationController
  authorize_resource

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = t('category.create.success')
    else
      form_error_messages_for @category
    end

    redirect_to administration_root_path(tab: 'category')
  end

  def update
    @category = Category.find(params[:id])

    if @category.update_attributes(category_params)
      flash[:notice] = t('category.update.success')
    else
      form_error_messages_for @category
    end

    redirect_to administration_root_path(tab: 'category')
  end

  private

  def category_params
    params.require(:category).permit(:name, :tags)
  end
end
