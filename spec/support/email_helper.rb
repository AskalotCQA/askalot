module EmailHelper
  def emails
    ActionMailer::Base.deliveries
  end

  def last_email
    emails.last
  end

  def reset_emails
    ActionMailer::Base.deliveries = []
  end
end
