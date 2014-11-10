class FacebookController < ApplicationController
  skip_before_action :verify_authenticity_token

  after_action :allow_inline_frame
  
  layout 'layouts/facebook'

  def redirect
    redirect_to "/#{params[:path]}"
  end

  private

  def allow_inline_frame
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
end
