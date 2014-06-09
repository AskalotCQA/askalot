class Administration::AssignmentsController < Administration::DashboardController
  authorize_resource

  # TODO (zbell) refactor

  def create
    @assignment = Assignment.new(assignment_params)

    if @assignment.save
      flash[:notice] = t('assignment.create.success')
    else
      form_error_messages_for @assignment
    end

    redirect_to administration_root_path(tab: params[:tab])
  end

  private

  def assignment_params
    params.require(:assignments).permit(:user_id, :category_id, :role_id)
  end
end
