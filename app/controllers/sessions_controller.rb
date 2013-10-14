class SessionsController < Devise::SessionsController
  def create
    service = Users::Authentication.new(Stuba::Ais, session, params[:user])

    if service.valid?
      service.create_user!

      redirect_to edit_user_registration_path
    else
      super
    end
  end
end
