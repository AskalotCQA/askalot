module WatchingsHelper
  def watchable_icon_tag(watchable, options = {})
    data = watchable_data watchable

    icon_tag data[:icon], options.merge(fixed: true)
  end

  def link_to_watchable(watchable, options = {})
    case watchable.class.name.downcase.to_sym
    when :category then link_to_category watchable, options.except(:length)
    when :question then link_to_question watchable, options
    when :tag      then link_to_tag watchable, options.except(:length)
    else watchable
    end
  end

  private

  def watchable_data(watchable)
    case watchable.class.name.downcase.to_sym
    when :category then { icon: :tags }
    when :question then { icon: :'question-circle' }
    when :tag      then { icon: :tag }
    else fail
    end
  end
end
