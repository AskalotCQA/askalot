module Shared
class Administration::AssignmentsController < Administration::DashboardController
  authorize_resource class: 'Shared::Assignment'

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
