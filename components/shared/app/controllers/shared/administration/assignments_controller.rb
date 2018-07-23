module Shared
class Administration::AssignmentsController < AdministrationController
  authorize_resource class: Shared::Assignment

  include Administration::FilterableCategories

  def index
    @assignments = Shared::Assignment.includes(:user, :role, category: :parent).where('admin_visible = true').order('categories.full_public_name', 'users.nick')
    @categories  = Shared::Category.includes(:parent).order(:depth, :full_tree_name)
    @users       = Shared::User::order(:login).all
    @assignment  ||= Shared::Assignment.new
    @roles       = Shared::Role.all.order(:name)

    if Rails.module.university?
      parent_ids = params.fetch('filter-categories', {}).fetch(:parent_id, []).reject(&:blank?)

      if parent_ids.empty?
        parent_ids                  = Array(Shared::Category.where(name: Shared::Tag.current_academic_year_value).first.id)
        params['filter-categories'] = { parent_id: parent_ids }
      end

      @assignments = include_only_child_categories(@assignments, parent_ids)
      @categories  = include_only_child_categories(@categories, parent_ids)
    end

    @assignments.each { |a| a.category.name = a.category.parent.name + ' - ' + a.category.name unless a.category.root? }
  end

  def create
    @assignment = Shared::Assignment.new(assignment_params)

    if @assignment.save
      form_message :notice, t('assignment.create.success')

      redirect_to shared.administration_assignments_path
    else
      index

      render :index
    end
  end

  def update
    @assignment = Shared::Assignment.find(params[:id])

    if @assignment.update_attributes(assignment_params)
      form_message :notice, t('assignment.update.success')
    else
      index

      render :index
    end

    redirect_to shared.administration_assignments_path
  end

  def destroy
    @assignment = Shared::Assignment.find(params[:id])

    if @assignment.destroy
      form_message :notice, t('assignment.delete.success')
    else
      form_error_message t('assignment.delete.failure')
    end

    redirect_to shared.administration_assignments_path
  end

  private

  def assignment_params
    params.require(:assignment).permit(:user_nick, :category_id, :role_id)
  end
end
end
