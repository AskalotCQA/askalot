module Mooc
  class UnitsController < Shared::ApplicationController
    require 'oauth/request_proxy/rack_request'
    require 'devise/strategies/authenticatable'

    include Shared::Events::Dispatch
    include Shared::Markdown::Process
    include Shared::MarkdownHelper

    skip_before_filter :verify_authenticity_token
    skip_before_filter :login_required

    layout 'mooc/unit'

    $oauth_creds = { Shared::Configuration.oauth.consumer_key => Shared::Configuration.oauth.consumer_secret }

    def show
      login unless signed_in?

      if params[:resource_link_id]
        @unit = Shared::Category.find_by lti_id: params[:resource_link_id]
        @unit = Shared::Category.create(name: params[:resource_link_id], lti_id: params[:resource_link_id]) if @unit.nil?
      else
        @unit = Shared::Category.find params[:id]
      end

      @questions = @unit.questions.order(created_at: :desc).page(params[:page]).per(20)
      @page_url = params[:custom_page_url]
    end

    protected

    def login
      redirect_to '/errors#show' unless authorize!

      u = User.find_by(login: params['user_id'])
      user_attributes = {login: params['user_id'], nick: params['lis_person_sourcedid'],
          email: params['lis_person_contact_email_primary'], role: params['roles']}
      u = User.create_without_confirmation! user_attributes if u.nil?

      sign_in(:user, u)
    end

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
