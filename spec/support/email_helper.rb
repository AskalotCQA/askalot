module EmailHelper
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def emails
    ActionMailer::Base.deliveries
  end

  def reset_emails
    ActionMailer::Base.deliveries = []
  end
end
