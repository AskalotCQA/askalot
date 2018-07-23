module Shared
class Administration::CategoriesController < AdministrationController
  authorize_resource class: Shared::Category

  include CategoriesHelper
  include Administration::FilterableCategories

  def index
    @categories = Shared::Category.includes(:assignments).order(:lft)

    if Rails.module.university?
      parent_ids = params.fetch('filter-categories', {}).fetch(:parent_id, []).reject(&:blank?)

      if parent_ids.empty?
        parent_ids                  = Array(Shared::Category.where(name: Shared::Tag.current_academic_year_value).first.id)
        params['filter-categories'] = { parent_id: parent_ids }
      end

      @categories = include_only_child_categories(@categories, parent_ids)
    end

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
      flash[:notice] = t('category.create.success')

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
      shared  = params[:shared] ? params[:shared].include?(category.id.to_s) : false
      askable = params[:askable] ? params[:askable].include?(category.id.to_s) : false
      visible = params[:visible] ? params[:visible].include?(category.id.to_s) : false

      if category.shared != shared || category.askable != askable || category.visible != visible
        category.shared  = shared
        category.askable = askable
        category.visible = visible

        category.save
      end
    end

    render json: { success: true }
  end

  def copy
    parent_category = Category.find_by full_tree_name: params[:parent_name]
    categories =  Category.where(id: params[:copied]).order(:lft).includes(:assignments) if params[:copied] && params[:copied].any?
    category_ids = {}

    render json: { success: true } and return unless categories

    categories.each do |category|
      category_copy = category.copy(parent_category, category_ids[category.parent_id])
      category_ids[category.id] = category_copy.id
    end

    render json: { success: true }
  end

  # TODO(zbell) add destroy?

  private

  def category_params
    params.require(:category).permit(:name, :description, :tags, :parent_id, :uuid, :shared, :askable, :visible, :third_party_hash, :teacher_assistant_ids => [])
  end
end
end
