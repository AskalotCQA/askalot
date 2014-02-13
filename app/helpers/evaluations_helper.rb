module EvaluationsHelper
  def evaluation_icon_tag(evaluable, options = {})
    # TODO(zbell) refactor to infinity :D
    case evaluable.evaluations.average(:value)
    when  -1000000 ...(-2.0 / 3) then icon_tag :'thumbs-o-down', class: :'text-danger'
    when (-2.0 / 3)...(+2.0 / 3) then icon_tag :'hand-o-right',  class: :'text-warning'
    when (+2.0 / 3)..  +1000000  then icon_tag :'thumbs-o-up',   class: :'text-success'
    else fail
    end
  end
end
