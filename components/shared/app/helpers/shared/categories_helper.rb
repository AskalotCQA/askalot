module Shared::CategoriesHelper
  def link_to_category(category, options = {}, content = category.full_public_name)
    link_to content, shared.questions_path(category: category.id), options
  end

  def names_for_teachers(teachers)
    text = teachers.length == 1 ? t('user.teacher_followed_category.one') : t('user.teacher_followed_category.more')

    text << teachers.map { |t| t.name.nil? ? t.nick : t.name }.join(', ')
  end

  def tree_table(objects, header = '', &block)
    objects = objects.order(:lft) if objects.is_a? Class

    return '' if objects.empty?

    root = nil
    parents = {}
    objects.group_by(&:parent_id).each do |key, item|
      key = key.nil? ? 0 : key
      root = root.nil? ? key : [root, key].min

      parents[key] = item.sort_by(&:name).reverse!
    end

    nodes = [parents[root]]

    output  = '<table class="treetable table">'
    output << "<tr>#{header}</tr>" unless header.blank?

    indent_span = '<span class="treetable-indent"></span>'
    path = [nil]

    while not nodes.empty? do
      while not nodes.last.empty? do
        node = nodes.last.pop()
        indent = indent_span * (path.size)
        tr_class = path.map { |id| "treetable-parent-#{id}" unless id.nil? }.join(' ')

        if parents.include?(node.id)
          expander = "<span class=\"treetable-expander treetable-expander-expanded\" data-id=\"#{node.id}\"></span>"
          nodes.push(parents[node.id])
          path.push(node.id)
        else
          expander = indent_span
        end

        output << "<tr class=\"#{tr_class}\">"
        output << capture(node, path.size - 1, &block).sub('<td>', '<td>' + indent + expander)
        output << '</tr>'
      end

      nodes.pop()
      path.pop()
    end

    output << '</table>'
    output.html_safe
  end

  def tree_view(objects, &block)
    objects = objects.sort_by(&:full_tree_name)

    parents = objects.group_by(&:parent_id)
    output  = ''

    path    = [nil]

    objects.each do |o|
      if o.parent_id != path.last
        if path.include?(o.parent_id)
          while path.last != o.parent_id
            path.pop
            output << '</ul></li>'
          end
        elsif o.visible?
          path << o.parent_id
          output << '<ul>'
        end
      else
        output << '</li>'
      end

      if o.visible?
        output << '<li>'
        output << capture(o, path.size - 1, &block)
      end
    end

    output << '</li></ul>' unless output.blank?
    output.html_safe
  end

  def active_categories(categories, questions_counts)
    categories.select { |category| (questions_counts[category.id] || 0) > 0 }
  end
end
