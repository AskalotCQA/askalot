module EmailHelper
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_emails
    ActionMailer::Base.deliveries = []
  end
end
