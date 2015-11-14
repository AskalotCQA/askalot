module University::LabelingsHelper
  def link_to_labeling(labeling, options = {})
    link_to_answer labeling.answer, options
  end
end
