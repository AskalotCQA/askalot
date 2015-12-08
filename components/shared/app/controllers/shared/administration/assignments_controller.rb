module Shared
class Administration::AssignmentsController < AdministrationController
  authorize_resource class: Shared::Assignment

  def index
    @assignments = Shared::Assignment.includes(:user, :category, :role).order('categories.name', 'users.nick')
    @assignments.each { |a| a.category.name = a.category.parent.name + ' - ' + a.category.name unless a.category.root? }
    @assignment ||= Shared::Assignment.new
  end

  def create
    @assignment = Shared::Assignment.new(assignment_params)

    if @assignment.save
      form_message :notice, t('assignment.create.success'), key: params[:tab]

      redirect_to administration_root_path(tab: params[:tab])
    else
      form_error_messages_for @assignment, flash: flash.now, key: params[:tab]

      render 'shared/administration/assignments/index'
    end
  end

  def update
    @assignment = Shared::Assignment.find(params[:id])

    if @assignment.update_attributes(assignment_params)
      form_message :notice, t('assignment.update.success'), key: params[:tab]
    else
      form_error_messages_for @assignment, key: params[:tab]
    end

    redirect_to administration_assignments_path
  end

  def destroy
    @assignment = Shared::Assignment.find(params[:id])

    if @assignment.destroy
      form_message :notice, t('assignment.delete.success'), key: params[:tab]
    else
      form_error_message t('assignment.delete.failure'), key: params[:tab]
    end

    redirect_to administration_assignments_path
  end

  private

  def assignment_params
    params.require(:assignment).permit(:user_nick, :category_id, :role_id)
  end
end
end
