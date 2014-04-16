module Applications::Analytics
  extend ActiveSupport::Concern

  protected
  # GA event logger
  def log_event(category, action, label = nil)
    session[:events] ||= Array.new
    session[:events] << {:category => category, :action => action, :label => label}
  end
end
