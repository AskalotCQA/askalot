module University
class FacebookController < ApplicationController
  skip_before_action :verify_authenticity_token

  after_action :allow_inline_frame

  layout 'layouts/facebook'

  def index
    @question = University::Questions::ToAnswerRecommender.next
  end

  def notification
    @content = params[:n]
    @link    = params[:r]

    fail unless !@link || @link =~ /\A\//
  end

  private

  def allow_inline_frame
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
end
end
