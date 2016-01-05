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

      return after_login_redirect if params[:custom_login_redirect]

      if params[:resource_link_id]
        @unit = Shared::Category.find_by lti_id: params[:resource_link_id]
        @unit = Shared::Category.create(name: params[:resource_link_id], lti_id: params[:resource_link_id]) if @unit.nil?
      else
        @unit = Shared::Category.find params[:id]
      end

      @questions = @unit.questions.order(created_at: :desc).page(params[:page]).per(20)
      @page_url = params[:custom_page_url] || ''
    end

    protected

    def login
      # FIXME (Filip Jandura) create custom error page
      redirect_to shared.error_500_path unless authorize!

      params['roles'] = :teacher if params['roles'] == 'Administrator'

      user = User.find_by(login: params['user_id'])
      user_attributes = { login: params['user_id'], nick: params['lis_person_sourcedid'],
          email: params['lis_person_contact_email_primary'], role: params['roles'].downcase }
      user = User.create_without_confirmation! user_attributes if user.nil?

      sign_in(:user, user)
    end

    def authorize!
      return false unless key = params['oauth_consumer_key']

      if secret = $oauth_creds[key]
        @tp = IMS::LTI::ToolProvider.new(key, secret, params)
      else
        return false
      end

      return false unless @tp.valid_request?(request)
      return false if Time.now.utc.to_i - @tp.request_oauth_timestamp.to_i > 60*60
      true
    end

    def after_login_redirect
      @url = params[:custom_page_url]

      render '/mooc/page/to_page_redirect'
    end
  end
end
