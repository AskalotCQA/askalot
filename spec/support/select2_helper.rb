module Select2Helper
  def fill_in_select2(selector, options={})
    page.find(:css, "#s2id_#{selector} input.select2-input").set options[:with]

    page.find(:css, 'ul.select2-results .select2-result-label').click

    wait_for_remote
  end
end
