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

      if params[:resource_link_id] && params[:context_id]
        if @context_id == -1
          context = Shared::Category.create({ name: 'unknown', uuid: params[:context_id].gsub('/', '-') })

          @context_id = context.id
          Shared::Context::Manager.current_context_id = context.id
        end

        lti_id = params[:resource_link_id].split('-', 2).last

        @unit = Shared::Category.in_contexts(Shared::Context::Manager.current_context_id).find_by lti_id: lti_id
        @unit = Shared::Category.create(name: 'unknown', uuid: 'unknown', lti_id: lti_id, parent_id: Shared::Context::Manager.current_context_id, askable: true) if @unit.nil?

        context_user = Shared::ContextUser.find_by(user: current_user, context_id: Shared::Context::Manager.current_context_id)

        if context_user.nil?
          Shared::ContextUser.create!(user: current_user, context_id: Shared::Context::Manager.current_context_id)
          teacher_context_assignment(@context_id) if params['roles'].in? ['Instructor', 'Administrator']
        end
      else
        @unit = Shared::Category.find params[:id]
      end

      redirect_to mooc.units_error_path(exception: t('unit.error.unknown_category_uuid')) if @unit.uuid == 'unknown'

      @question               = Shared::Question.new
      @question.category      = @unit
      @question.question_type = Shared::QuestionType.questions.first

      @questions = @unit.related_questions.order(created_at: :desc).page(params[:page]).per(20)
    end

    protected

    def login
      return false unless authorize!

      begin
        user = User.find_by(login: params['user_id'])

        raise t('unit.error.account_not_created_yet') if user.nil? && (!params['lis_person_sourcedid'] || !params['lis_person_contact_email_primary'])

        if user.nil?
          user_attributes = { login: params['user_id'], nick: params['lis_person_sourcedid'], email: params['lis_person_contact_email_primary'] }
          user = User.create_without_confirmation! user_attributes
        end

        sign_in(:user, user)
      rescue => e
        @exception = e.message

        return false
      end

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

    def teacher_context_assignment(context_category_id)
      # In admin UI: Admin
      # In LTI request: Instructor
      # In Askalot: :teacher

      # In admin UI: Staff
      # In LTI request: Administrator
      # In Askalot: :teacher_assistant

      # Course team members with the Admin role help you manage your course. They can do all of the tasks that Staff can do, and can also add and remove the Staff and Admin roles, discussion moderation roles, and the beta tester role to manage course team membership. You can only give course team roles to enrolled users.
      # In admin UI: Administrator > Staff > everybody else
      # In LTI: Instructor > Administrator > everybody else

      params['roles'] = :teacher if params['roles'] == 'Instructor'
      params['roles'] = :teacher_assistant if params['roles'] == 'Administrator'

      Shared::Assignment.find_or_create_by!(role: Shared::Role.find_by!(name: params['roles']), user: current_user, category_id: context_category_id, admin_visible: true, parent: nil)
    end
  end
end
