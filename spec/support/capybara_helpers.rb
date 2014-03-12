module CapybaraHelpers
  def click_link(locator, options = {})
    begin
      find(:link, locator, options).click 
    rescue Exception => e
      return page.evaluate_script("$(\"a:contains('#{locator}')\").click()") if example.metadata[:js]

      raise e
    end
  end

  def navigate_back
    page.evaluate_script('window.history.back()')
  end

  def navigate_forward
    page.evaluate_script('window.history.forward()')
  end
end
