module Mooc
class LtiController < ApplicationController
  require 'oauth/request_proxy/rack_request'
  require 'devise/strategies/authenticatable'

  skip_before_filter  :verify_authenticity_token

  $oauth_creds = {"test" => "secret", "testing" => "supersecret"}

  def login
    redirect_to 'errors#show' unless authorize!

    u = User.find_by(login: "user#{params['user_id']}")

    #TODO (janduraf) add specifis roles to DB according edX system role: params['roles']
    u = User.create_without_confirmation! login: "user#{params['user_id']}", nick: params['lis_person_sourcedid'],
                                          email: params['lis_person_contact_email_primary'] if u.nil?

    sign_in(:user, u) unless signed_in?
    redirect_to '/questions'
  end

  protected

  def authorize!
    if key = params['oauth_consumer_key']
      if secret = $oauth_creds[key]
        @tp = IMS::LTI::ToolProvider.new(key, secret, params)
      else
        @tp = IMS::LTI::ToolProvider.new(nil, nil, params)
        @tp.lti_msg = "Your consumer didn't use a recognized key."
        @tp.lti_errorlog = "You did it wrong!"
        show_error "Consumer key wasn't recognized"
        return false
      end
    else
      show_error "No consumer key"
      return false
    end

    if !@tp.valid_request?(request)
      show_error "The OAuth signature was invalid"
      return false
    end

    if Time.now.utc.to_i - @tp.request_oauth_timestamp.to_i > 60*60
      show_error "Your request is too old."
      return false
    end

    # this isn't actually checking anything like it should, just want people
    # implementing real tools to be aware they need to check the nonce
    if was_nonce_used_in_last_x_minutes?(@tp.request_oauth_nonce, 60)
      show_error "Why are you reusing the nonce?"
      return false
    end

    return true
  end

  def was_nonce_used_in_last_x_minutes?(nonce, minutes=60)
    # some kind of caching solution or something to keep a short-term memory of used nonces
    false
  end
end
end
