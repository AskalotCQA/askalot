module Events::Log
  extend ActiveSupport::Concern

  included do
    before_action :log_current_action
  end

  def events_management
    @events_management ||= Events::Management.new
  end

  def log(data)
    events_management.log(data.merge snapshot: { request: request, params: params, user: current_user })
  end

  def log_current_action
    log action: "#{params[:controller]}.#{params[:action]}"
  end
end
