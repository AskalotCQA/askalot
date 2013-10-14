class SessionsController < Devise::SessionsController
  def create
    service = Users::Authentication.new(Stuba::Ais, params[:user])

    service.create_user! if service.authorized?

    super
  end
end
