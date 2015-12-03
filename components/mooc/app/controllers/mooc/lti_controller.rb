module Mooc
class LtiController < ApplicationController
  require 'oauth/request_proxy/rack_request'
  require 'devise/strategies/authenticatable'

  skip_before_filter  :verify_authenticity_token

  $oauth_creds = { Shared::Configuration.oauth.consumer_key => Shared::Configuration.oauth.consumer_secret }

  def login
    redirect_to 'errors#show' unless authorize!

    u = User.find_by(login: params['user_id'])
    u = User.create_without_confirmation! login: params['user_id'], nick: params['lis_person_sourcedid'],
                                          email: params['lis_person_contact_email_primary'], role: params['roles'] if u.nil?

    sign_in(:user, u) unless signed_in?
    redirect_to '/questions'
  end

  protected

  def authorize!
    return false unless key = params['oauth_consumer_key']

    if secret = $oauth_creds[key]
      @tp = IMS::LTI::ToolProvider.new(key, secret, params)
    else
      @tp = IMS::LTI::ToolProvider.new(nil, nil, params)

      return false
    end

    return false unless @tp.valid_request?(request)
    return false if Time.now.utc.to_i - @tp.request_oauth_timestamp.to_i > 60*60
    true
  end
end
end
