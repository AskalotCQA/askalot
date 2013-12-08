module HistoryHelper
  def navigate_back
    page.evaluate_script('window.history.back()')
  end

  def navigate_forward
    page.evaluate_script('window.history.forward()')
  end
end
