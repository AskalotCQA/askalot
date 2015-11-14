module WatchingsHelper
  def watchable_icon_tag(watchable, options = {})
    data  = watchable_data watchable
    color = watchable.is_a?(Deletable) && watchable.deleted ? :'text-muted' : :'text-primary'

    icon_tag data[:icon], options.merge(class: color, fixed: true)
  end

  def watchable_content(watchable, options = {})
    options[:class] = Array.wrap(options[:class]) << :'text-muted' if watchable.is_a?(Deletable) && watchable.deleted

    link_to_watchable watchable, options.reverse_merge(length: 80)
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
