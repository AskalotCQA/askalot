module QuestionsHelper
  def wait_for_questions_polling
    wait_for_remote(Configuration.poll.default)
  end
end
