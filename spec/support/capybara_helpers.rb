module CapybaraHelpers
  def click_link(locator, options = {})
    find(:link, locator, options).click rescue page.evaluate_script("$(\"a:contains('#{locator}')\").click()")
  end

  def navigate_back
    page.evaluate_script('window.history.back()')
  end

  def navigate_forward
    page.evaluate_script('window.history.forward()')
  end
end
