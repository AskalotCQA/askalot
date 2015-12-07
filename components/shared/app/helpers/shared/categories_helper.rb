module Shared::CategoriesHelper
  def group_categories_by_prefix(categories)
    mixed  = []
    groups = categories.inject(Hash.new) do |groups, category|
      if match = category.name.match(/[A-Z]{2,}\s/)
        (groups[match[0].strip.downcase.to_sym] ||= []) << category
      else
        mixed << category
      end

      groups
    end

    groups.sort_by { |key, _| key }
    groups[:mixed] = mixed
    groups
  end

  def link_to_category(category, options = {})
    link_to category.name, shared.questions_path(tags: category.tags.join(',')), options
  end

  def names_for_teachers(teachers)
    text = teachers.length == 1 ? t('user.teacher_followed_category.one') : t('user.teacher_followed_category.more')

    text << teachers.map { |t| t.name }.join(', ')
  end

  def tree_table(objects, header = '', &block)
    objects = objects.order(:lft) if objects.is_a? Class

    return '' if objects.size == 0

    parents = objects.group_by(&:parent_id)
    output  = '<table class="treetable table">'
    output << '<tr>' << header << '</tr>' unless header.blank?

    path    = [nil]

    objects.each do |o|
      if o.parent_id != path.last
        # We are on a new level, did we descend or ascend?
        if path.include?(o.parent_id)
          # Remove the wrong trailing path elements
          while path.last != o.parent_id
            path.pop
          end
        else
          path << o.parent_id
        end
      end

      ident_span = '<span class="treetable-indent"></span>'
      expander = parents[o.id] ? '<span class="treetable-expander treetable-expander-expanded" data-id="'+ o.id.to_s + '"></span>' : ident_span
      indent   = ident_span * (path.size - 1)

      output << '<tr class="' << path.map { |id| 'treetable-parent-' + id.to_s unless id.nil? }.join(' ') << '">'
      output << capture(o, path.size - 1, &block).sub('<td>', '<td>' + indent + expander)
      output << '</tr>'
    end

    output << '</table>'
    output.html_safe
  end
end
