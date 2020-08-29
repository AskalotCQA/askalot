module Shared
class ApplicationController < ActionController::Base
  helper Mooc::Engine.helpers if Rails.module.mooc?

  before_action :determine_context
  around_action :set_locale

  protected

  # concerns order is significant
  include Shared::Applications::Security
  include Shared::Applications::Flash
  include Shared::Applications::Form
  include Shared::Applications::Tab

  include Shared::Events::Log

  include Shared::Facebook::Modal
  include Shared::Slido::Flash if Shared::Configuration.enable.slido_events?
  include (Rails.module.classify + '::Application').constantize

  helper_method :contexts

  def current_ability
    @current_ability ||= Shared::Ability.new(current_user)
  end

  def determine_context
    if params[:context_id]
      context_id = Shared::Context::Manager.determine_context_id(params[:context_id].gsub '/', '-')
    elsif params[:context_uuid] && params[:context_uuid] != 'default'
      context_id = Shared::Context::Manager.determine_context_id(params[:context_uuid].gsub ' ', '+')
    else
      context_id = Shared::Context::Manager.default_context_id(current_user)
    end

    @context_id = context_id
    Shared::Context::Manager.current_context_id = context_id

    if Rails.module.mooc?
      Rails.application.routes.default_url_options[:context_uuid] = Shared::Context::Manager.context_category.uuid

      redirect_to "#{relative_url_root}/#{Shared::Context::Manager.context_category.uuid}" and return if !params[:context_uuid]
      redirect_to request.fullpath.gsub(/#{Regexp.escape(params[:context_uuid])}/, Shared::Context::Manager.context_category.uuid) if !request.post? && params[:context_uuid] != Shared::Context::Manager.context_category.uuid
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

  private

  def set_locale(&action)
    lang = params[:lang] || cookies[:lang] || I18n.default_locale
    lang = ['en', 'sk'].include?(lang) ? lang : 'sk'

    I18n.with_locale(lang, &action)
    cookies[:lang] = lang
  end
end
end
