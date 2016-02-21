module Mooc::Application
  extend ActiveSupport::Concern

  included do
    layout 'mooc/application'
    prepend_view_path 'components/mooc/app/views'

    before_action :login_required, :redirect_if_params

    def determine_context
      @context = session[:context] = params[:context] if params[:context]
      @context = session[:context] if session[:context]
      @context = :root if @context.nil?

      Shared::ApplicationHelper.current_context=(@context)
    end

    private

    def login_required
      unless user_signed_in?
        @url = params[:login_url]

        render '/mooc/page/to_login_redirect' if params[:login_url]
        render '/mooc/page/no_login_url' unless params[:login_url]
      end
    end

    def redirect_if_params
      redirect_to params[:redirect] if params[:redirect]
    end
  end
end
