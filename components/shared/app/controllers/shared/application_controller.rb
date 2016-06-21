module Shared
class ApplicationController < ActionController::Base
  helper Mooc::Engine.helpers if Rails.module.mooc?

  before_action :determine_context

  protected

  # concerns order is significant
  include Shared::Applications::Security
  include Shared::Applications::Flash
  include Shared::Applications::Form
  include Shared::Applications::Tab

  include Shared::Events::Log

  include Shared::Facebook::Modal
  include Shared::Slido::Flash
  include (Rails.module.classify + '::Application').constantize

  helper_method :contexts

  def current_ability
    @current_ability ||= Shared::Ability.new(current_user)
  end

  def determine_context
    context = params[:context] ? context_from_params : Shared::Context::Manager.default_context(current_user)

    Rails.application.routes.default_url_options[:context] = Shared::Context::Manager.current_context if Rails.module.mooc?

    if Rails.module.mooc?
      redirect_to "#{relative_url_root}/#{context}" if !params[:context]
      redirect_to request.fullpath.sub('default', context.to_s) if !request.post? && params[:context] == 'default' && context != 'default'
    end

    Shared::Context::Manager.current_context = context
    Shared::Context::Manager.context_category_by_id context

    @context_category = Shared::Context::Manager.context_category
    @context = context
  end

  def contexts
    return [] unless user_signed_in?

    if current_user.role? :administrator
      @contexts ||= Shared::Category.roots
    else
      @contexts ||= current_user.assigned_categories(:teacher).select { |t| t.parent_id.nil? }
    end
  end

  private

  def context_from_params
    return Shared::Context::Manager.determine_context_id(params[:context_id].gsub '/', '-') if params[:context_id]
    return params[:context] unless params[:context].is_a?(String)
    return params[:context].to_i if params[:context].is_number?
    return Shared::Context::Manager.default_context(current_user) if params[:context] == 'default'
    return Shared::Context::Manager.determine_context_id(params[:context]) if params[:context].is_a?(String)
  end
end
end
