module Concerns::Logging
  extend ActiveSupport::Concern

  def logger
    @logger ||= Events::Management.new
  end

  def log(data)
    logger.log(data.merge snapshot: { request: request, params: params, user: current_user })
  end

  def log_current_action
    log action: "#{params[:controller]}.#{params[:action]}"
  end
end
