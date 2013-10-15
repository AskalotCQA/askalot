module Concerns::Logging
  extend ActiveSupport::Concern

  def logger
    @logger ||= Events::Management.new request: request, params: params, user: current_user
  end

  def log(data)
    logger.log data
  end

  # TODO (zbell) impl
#  def log_controller_action
#    logger.log action: "#{params[:action]}.#{params[:action]}"
#  end
end
