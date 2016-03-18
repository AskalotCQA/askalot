module Shared::PollingHelper
  def wait_for_questions_polling
    wait_for_remote(Shared::Configuration.poll.default)
  end
end
