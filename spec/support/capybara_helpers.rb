module CapybaraHelpers
  extend ActiveSupport::Concern

  included do
    alias :original_fill_in :fill_in
    alias :original_select :select

    def fill_in(*args)
      return fill_in_select2(*args) if args.last.is_a?(Hash) && args.last[:as] == :select2

      original_fill_in(*args)
    end

    def select(*args)
      return select2(*args) if args.last.is_a?(Hash) && args.last[:as] == :select2

      original_select(*args)
    end
  end

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

  def fill_in_select2(selector, options = {})
    page.find(:css, "#s2id_#{selector} input.select2-input").set options[:with]

    page.document.find(:css, 'ul.select2-results .select2-result-label').click

    wait_for_remote
  end

  def select2(value, options)
    raise "Must pass a hash containing 'from'." unless options.is_a?(Hash) and [:from].any? { |k| options.has_key? k }

    label = options[:from]

    within "#s2id_#{label}" do
      find('a.select2-choice').click
    end

    within '#select2-drop .select2-results' do
      # TODO (smolnar) figure out xpath

      all('li.select2-result').each do |element|
        return element.click if element.text == value
      end
    end

    raise "Could not find #{value} in #{label}."
  end
end
