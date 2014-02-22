module CapybaraHelpers
  def click_link(locator, options = {})
    find(:link, locator, options).click rescue page.evaluate_script("$(\"a:contains('#{locator}')\").click()")
  end
end
