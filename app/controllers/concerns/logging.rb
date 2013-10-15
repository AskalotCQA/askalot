module Concerns::Logging
  extend ActiveSupport::Concern

  def logger
    @logger ||= Events::Management.new request: request, user: current_user
  end

  def log(data)
    logger.log data
  end
end
