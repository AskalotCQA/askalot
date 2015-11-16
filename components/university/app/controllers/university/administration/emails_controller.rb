module University
class Administration::EmailsController < Administration::DashboardController

  def create
    authorize! :create, University::Email

    if params[:test]
      University::Mailers::CommunityMailerService.deliver_test_email!(email_params)
      form_message :notice, t('email.create_test.success'), key: 'emails'
    else
      @email = University::Email.new(email_params)

      if @email.save
        form_message :notice, t('email.create.success'), key: 'emails'
      else
        form_message :error, t('email.create.failure'), key: 'emails'
      end
    end
    redirect_to administration_root_path(tab: 'emails')
  end

  private

  def email_params
    email = params.require(:email).permit(:subject, :body, :send_html_email).deep_merge({ user: current_user, status: false })
    email.deep_merge({ send_html_email: email[:send_html_email] == "1" })
  end
end
end
