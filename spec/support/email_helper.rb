module EmailHelper
  def last_email
    ActionMailer::Base.deliveries.last
  end
end
