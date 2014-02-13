module EvaluationsHelper
  Infinity = 1.0 / 0.0

  def evaluation_icon_tag(evaluable, options = {})
    data = evaluation_data evaluable

    icon_tag data[:icon], options.merge(class: data[:color])
  end

  private

  def evaluation_data(evaluable)
    case evaluable.evaluations.average(:value).to_f
      when  -Infinity...(-2.0 / 3) then { color: :'text-danger',  icon: :'thumbs-o-down' }
      when (-2.0 / 3)...(+2.0 / 3) then { color: :'text-warning', icon: :'hand-o-right' }
      when (+2.0 / 3)..  +Infinity then { color: :'text-success', icon: :'thumbs-o-up' }
      else fail
    end
  end
end
