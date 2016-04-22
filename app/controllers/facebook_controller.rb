class FacebookController < ActionController::Base
  before_action :authenticate_user!

  skip_before_filter :verify_authenticity_token

  def facebook
    @auth    = request.env['omniauth.auth']
    @proxy   = FbGraph::User.me(@auth.credentials.token)
    @friends = @proxy.friends
    @likes   = @proxy.likes

    current_user.from_omniauth(@auth, @friends, @likes)

    redirect_to shared.root_path
  end
end
