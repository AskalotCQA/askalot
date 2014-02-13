module EvaluationsHelper
  Infinity = 1.0 / 0.0

  def evaluation_badge_tag(evaluable, options = {})
    data = evaluation_data evaluable

    content_tag :span, options.merge(class: :'fa-stack') do
      icon_tag(:circle, class: [:'fa-stack-2x', data[:color]]) + icon_tag(data[:icon], class: [:'fa-stack-1x', :'text-inverse'])
    end
  end

  def evaluation_icon_tag(evaluable, options = {})
    data = evaluation_data evaluable

    icon_tag data[:icon], options.merge(class: data[:color])
  end

  private

  def evaluation_data(evaluable)
    case evaluable.evaluations.average(:value).to_f
      when  -Infinity...(-2.0 / 3) then { color: :'text-danger',  icon: :'thumbs-o-down' }
      when (-2.0 / 3)...(+2.0 / 3) then { color: :'text-muted',   icon: :'hand-o-right' }
      when (+2.0 / 3)..  +Infinity then { color: :'text-success', icon: :'thumbs-o-up' }
      else fail
    end
  end
end
