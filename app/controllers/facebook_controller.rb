class FacebookController < ApplicationController
  after_action :allow_facebook_iframe
  skip_before_action :verify_authenticity_token

  layout 'layouts/facebook'

  def redirect
    path = "/#{params[:path]}"

    redirect_to path
  end

  private

  def allow_facebook_iframe
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
end
