module CapybaraHelpers
  def click_link(locator, options = {})
    begin
      find(:link, locator, options).click
    rescue Exception => e
      raise e unless example.metadata[:js]

      Timeout.timeout(3) { page.evaluate_script("$(\"a:contains('#{locator}')\").click()") } rescue raise e
    end
  end

  def navigate_back
    page.evaluate_script('window.history.back()')
  end

  def navigate_forward
    page.evaluate_script('window.history.forward()')
  end
end
