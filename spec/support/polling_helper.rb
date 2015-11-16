module PollingHelper
  def wait_for_questions_polling
    wait_for_remote(University::Configuration.poll.default)
  end
end
