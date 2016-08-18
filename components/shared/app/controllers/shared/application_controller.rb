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
    if params[:context_id]
      context = Shared::Context::Manager.determine_context_id(params[:context_id].gsub '/', '-')
    elsif params[:context] && params[:context] != 'default'
      context = Shared::Context::Manager.determine_context_id(params[:context].gsub ' ', '+')
    else
      context = Shared::Context::Manager.default_context(current_user)
    end

    @context = context
    Shared::Context::Manager.current_context = context

    if Rails.module.mooc?
      Rails.application.routes.default_url_options[:context] = context

      redirect_to "#{relative_url_root}/#{Shared::Context::Manager.context_category.uuid}" and return if !params[:context]
      redirect_to request.fullpath.gsub(/#{Regexp.escape(params[:context])}/, Shared::Context::Manager.context_category.uuid) if !request.post? && params[:context] != Shared::Context::Manager.context_category.uuid
    end
  end

  def contexts
    return [] unless user_signed_in?

    if current_user.role? :administrator
      @contexts ||= Shared::Category.roots
    else
      @contexts ||= current_user.assigned_categories(:teacher).select { |t| t.parent_id.nil? }
    end
  end
end
end
