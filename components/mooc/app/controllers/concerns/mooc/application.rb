module Mooc::Application
  extend ActiveSupport::Concern

  included do
    layout 'mooc/application'
    prepend_view_path 'components/mooc/app/views'

    # order is significant
    before_action :check_askalot_page_url, :login_required

    private

    def login_required
      unless user_signed_in?
        @url = params[:login_url].gsub ' ', '+' if params[:login_url]

        render '/mooc/page/to_login_redirect' if params[:login_url]
        render '/mooc/page/no_login_url' unless params[:login_url]
      end
    end

    def check_askalot_page_url
      return if Shared::Context::Manager.current_context == 'default'

      category = Shared::Category.find(Shared::Context::Manager.current_context)

      redirect_to controller: :units, action: :error, exception: 'Askalot page url is not set up. Please visit global view first.' and return if category.askalot_page_url.nil? && params[:controller] == 'mooc/units' && params[:action] == 'show'

      return unless category.askalot_page_url.nil?
      return unless params[:page_url]

      category.askalot_page_url = params[:page_url].gsub ' ', '+'

      category.save!
    end
  end
end
