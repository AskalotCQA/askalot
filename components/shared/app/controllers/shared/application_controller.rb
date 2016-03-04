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
    context = params[:context] || Shared::Context::Manager.default_context
    context_id = context.is_a?(String) ? context.gsub(/[^0-9]/, '').to_i : nil
    context = context_id if context_id.is_a?(Fixnum) && context_id != 0
    context = Shared::Context::Manager.determine_context_id(context) unless context_id.nil? || context_id != 0

    @context = context
    Shared::Context::Manager.current_context = context
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
