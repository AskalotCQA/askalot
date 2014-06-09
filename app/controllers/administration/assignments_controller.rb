class Administration::AssignmentsController < Administration::DashboardController
  authorize_resource

  def create
    @assignment = Assignment.new(assignment_params)

    if @assignment.save
      form_message :notice, t('assignment.create.success'), key: params[:tab]

      redirect_to administration_root_path(tab: params[:tab])
    else
      form_error_messages_for @assignment, flash: flash.now, key: params[:tab]

      render_dashboard
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])

    if @assignment.destroy
      form_message :notice, t('assignment.update.success'), key: params[:tab]
    else
      form_error_message t('assignment.update.success'), key: params[:tab]
    end

    redirect_to administration_root_path(tab: params[:tab])
  end

  private

  def assignment_params
    params.require(:assignments).permit(:user_id, :category_id, :role_id)
  end
end
