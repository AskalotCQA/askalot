module Mooc::Application
  extend ActiveSupport::Concern

  included do
    layout 'mooc/application'
    prepend_view_path 'components/mooc/app/views'

    # order is significant
    before_action :login_required, :check_askalot_page_url, :redirect_if_params

    private

    def login_required
      unless user_signed_in?
        @url = params[:login_url].gsub ' ', '+' if params[:login_url]

        render '/mooc/page/to_login_redirect' if params[:login_url]
        render '/mooc/page/no_login_url' unless params[:login_url]
      end
    end

    def redirect_if_params
      redirect_to params[:redirect] if params[:redirect]
    end

    def check_askalot_page_url
      return if Shared::Context::Manager.current_context == 'default'

      category = Shared::Category.find(Shared::Context::Manager.current_context)

      return unless category.askalot_page_url.nil?

      category.askalot_page_url = params[:page_url]

      category.save!
    end
  end
end
