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

  def copy
    parent_category = Category.find_by full_tree_name: params[:parent_name]
    categories =  Category.where(id: params[:copied]).order(:lft).includes(:assignments) if params[:copied] && params[:copied].any?
    category_ids = {}
    assignment_ids = {}

    if categories
      categories.each do |category|
        category_copy = category.copy(parent_category, category_ids[category.parent_id])
        category_ids[category.id] = category_copy.id

        assignments = category.assignments

        if assignments
          assignments.each do |assignment|
            assignment_copy = assignment.copy(category_copy.id)
            if assignment_copy
              assignment_ids[assignment.id] = assignment_copy.id
            end
          end
        end

        watchings = Shared::Watching.where(watchable_id: category.id, watchable_type: 'Shared::Category')

        if watchings
          watchings.each do |watching|
            if watching.watcher.role == :teacher || category.teachers.include?(watching.watcher) ||
                category.full_tree_name.include?('Všeobecné')
              watching.copy(assignment_copy.id, category_copy.ancestors[1].id)
            end
          end
        end
      end
    end

    render json: { success: true }
  end

  # TODO(zbell) add destroy?

  private

  def category_params
    params.require(:category).permit(:name, :description, :tags, :parent_id, :uuid, :shared, :askable, :third_party_hash, :teacher_assistant_ids => [])
  end
end
end
