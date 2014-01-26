module Logging
  def events
    Event.all
  end

  def last_event
    events.order(created_at: :desc).first
  end
end
