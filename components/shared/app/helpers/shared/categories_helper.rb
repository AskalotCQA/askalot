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
end
