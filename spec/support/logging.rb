module Logging
  def events
    University::Event.all
  end

  def last_event
    events.order(created_at: :desc).first
  end
end
