module Shared
class FacebookController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :login_required if Rails.module.mooc?

  after_action :allow_inline_frame

  layout 'shared/facebook'

  def index
    @question = Shared::Questions::ToAnswerRecommender.next
  end

  def notification
    @content = params[:n]
    @link    = params[:r]

    fail unless !@link || @link =~ /\A\// if Rails.module.university?
  end

  private

  def allow_inline_frame
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
end
end
