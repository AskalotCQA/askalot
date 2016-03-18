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

    def error
      @exception = params[:exception]
    end

    def show
      redirect_to mooc.units_error_path(exception: @exception) and return unless signed_in? || login

      return after_login_redirect if params[:custom_login_redirect]

      lti_id = params[:resource_link_id]

      if lti_id
        lti_id = lti_id.split('-', 2).last
        course_id = lti_id.split('-', 3).last.split('-', 2).first


        Shared::Category.transaction do
          @unit = Shared::Category.find_by lti_id: lti_id
          @unit = Shared::Category.create(name: lti_id, lti_id: lti_id, askable: true) if @unit.nil?
        end

        Shared::ContextUser.find_or_create_by!(user: current_user, context_id: @unit.root.id) unless @unit.parent_id.nil?
      else
        @unit = Shared::Category.find params[:id]
      end

      @question = Shared::Question.new
      @question.category = @unit

      @questions = @unit.related_questions.order(created_at: :desc).page(params[:page]).per(20)
      @page_url = params[:page_url] || ''
    end

    protected

    def login
      return false unless authorize!

      params['roles'] = :teacher if params['roles'] == 'Administrator'
      params['roles'] = :teacher_assistant if params['roles'] == 'Teacher'

      user = User.find_by(login: params['user_id'])
      user_attributes = { login: params['user_id'], nick: params['lis_person_sourcedid'],
          email: params['lis_person_contact_email_primary'], role: params['roles'].downcase }
      user = User.create_without_confirmation! user_attributes if user.nil?

      sign_in(:user, user)

      true
    end

    def authorize!
      begin
        raise 'LTI consumer key not provided' unless key = params['oauth_consumer_key']
        raise 'LTI secret does not match' unless secret = $oauth_creds[key]

        @tp = IMS::LTI::ToolProvider.new(key, secret, params)

        raise 'LTI request is not valid' unless @tp.valid_request?(request)
        raise 'LTI request is too old' if Time.now.utc.to_i - @tp.request_oauth_timestamp.to_i > 60*60
      rescue => e
        @exception = e.message

        return false
      end

      # FIXME (huna|jandura) check if oauth nonce was used in the last x minutes
      true
    end

    def after_login_redirect
      @url = params[:page_url]

      render '/mooc/page/to_page_redirect'
    end
  end
end
