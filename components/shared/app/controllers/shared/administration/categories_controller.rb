module Shared
class Administration::CategoriesController < AdministrationController
  authorize_resource class: Shared::Category

  include CategoriesHelper

  def index
    @categories = Shared::Category.includes(:assignments).order(:lft)
    @category ||= Shared::Category.new
  end

  def new
    @category = Shared::Category.new params.permit([:parent_id, :uuid])
  end

  def edit
    @category = Shared::Category.find params[:id]
  end

  def create
    @category = Shared::Category.new(category_params)

    if @category.save
      form_message :notice, t('category.create.success')

      redirect_to shared.administration_categories_path
    else
      form_error_messages_for @category, flash: flash.now

      render :new
    end
  end

  def update
    @category = Shared::Category.find(params[:id])

    if @category.update_attributes(category_params)
      form_message :notice, t('category.update.success')
    else
      form_error_messages_for @category
    end

    redirect_to shared.administration_categories_path
  end

  def update_settings
    Shared::Category.all.each do |category|
      shared = params[:shared] ? params[:shared].include?(category.id.to_s) : false
      askable =  params[:askable] ? params[:askable].include?(category.id.to_s) : false

      if category.shared != shared || category.askable != askable
        category.shared  = shared
        category.askable = askable

        category.save
      end
    end

    render json: { success: true }
  end

  # TODO(zbell) add destroy?

  private

  def category_params
    params.require(:category).permit(:name, :description, :tags, :parent_id, :uuid, :shared, :askable, :teacher_assistant_ids => [])
  end
end
end
