class Administration::EmailsController < Administration::DashboardController
  #authorize_resource
  skip_authorization_check
  before_action :authenticate_user!

  def create
    form_message :notice, "Email bol uspesne odoslany", key: 'emails'

    if params[:test]
      Mailers::CommunityMailerService.deliver_test_mail!(params[:text], params[:subject], current_user, params[:html])
    else
      Mailers::CommunityMailerService.deliver_mails!(params[:text], params[:subject], params[:html])
    end

    redirect_to administration_root_path(tab: 'emails')
  end
end
