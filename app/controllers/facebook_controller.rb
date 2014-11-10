class FacebookController < ApplicationController
  skip_before_action :verify_authenticity_token

  after_action :allow_inline_frame
  
  layout 'layouts/facebook'

  def index
    @question = Questions::ToAnswerRecommender.next
  end

  def notification
    fail unless params[:n] =~ /\A\//

    @link = params[:n]
  end

  private

  def allow_inline_frame
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
end
