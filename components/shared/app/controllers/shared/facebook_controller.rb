module Shared
class FacebookController < ApplicationController
  skip_before_action :verify_authenticity_token

  after_action :allow_inline_frame

  layout 'shared/facebook'

  def index
    @question = Shared::Questions::ToAnswerRecommender.next
  end

  def notification
    @content = params[:n]
    @link    = params[:r]

    puts @content.inspect
    puts @link.inspect
    fail unless !@link || @link =~ /\A\//
  end

  private

  def allow_inline_frame
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
end
end
