module Shared::WatchingsHelper
  def watchable_icon_tag(watchable, options = {})
    data  = watchable_data watchable
    color = watchable.is_a?(Shared::Deletable) && watchable.deleted || !watchable.available_in_current_context? ? :'text-muted' : :'text-primary'

    icon_tag data[:icon], options.merge(class: color, fixed: true)
  end

  def watchable_content(watchable, options = {})
    if watchable.is_a?(Shared::Deletable) && watchable.deleted || !watchable.available_in_current_context?
      options[:class] = Array.wrap(options[:class]) << :'text-muted'

      return static_watchable watchable, options.reverse_merge(length: 80)
    end

    link_to_watchable watchable, options.reverse_merge(length: 80)
  end

  def link_to_watchable(watchable, options = {})
    case watchable.class.name
    when 'Shared::Category' then link_to_category watchable, options.except(:length)
    when 'Shared::Question' then link_to_question watchable, options
    when 'Shared::Tag'      then link_to_tag watchable, options.except(:length)
    else watchable
    end
  end

  def static_watchable(watchable, options = {})
    case watchable.class.name
      when 'Shared::Category' then watchable.full_public_name
      when 'Shared::Question' then question_title_preview(watchable, options)
      when 'Shared::Tag'      then watchable.value
      else watchable
    end
  end

  private

  def watchable_data(watchable)
    case watchable.class.name
    when 'Shared::Category' then { icon: :tags }
    when 'Shared::Question' then { icon: :'question-circle' }
    when 'Shared::Tag'      then { icon: :tag }
    else fail
    end
  end
end
