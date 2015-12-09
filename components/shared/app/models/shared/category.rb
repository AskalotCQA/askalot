module Shared
class Category < ActiveRecord::Base
  acts_as_nested_set

  include Shared::Watchable

  include Shared::Categories::Searchable

  has_many :questions, dependent: :restrict_with_exception
  has_many :answers, through: :questions

  has_many :assignments, dependent: :destroy
  has_many :users, through: :assignments
  has_many :roles, through: :assignments

  validates :name, presence: true, uniqueness: { scope: :parent_id }

  scope :with_slido, -> { where.not(slido_username: nil) }

  self.table_name = 'categories'

  def count
    questions.reload.size
  end

  def effective_tags
    tags << Shared::Tag.current_academic_year_value
  end

  def tags=(values)
    write_attribute(:tags, Shared::Tags::Extractor.extract(values))
  end

  def teachers
    assignments.where({ category_id: id, role_id: 2 }).map { |t| t.user }
  end

  def has_teachers?
    teachers.length > 0
  end

  def name_with_teacher_supported
    return name + I18n.t('category.teacher_supported') if has_teachers?
    name
  end

  def self.groups_in_context(context)
    groups = []
    empty = []

    find_by(name: context).children.sort_by(&:name).each do |group|
      if group.children.size == 0
        empty << group
      else
        groups << group.children.each do |category|
          category.name = group.name + ' - ' + category.name
        end
      end
    end

    groups << empty unless empty.empty?
    groups
  end

  def self.categories_in_context(context)
    categories = []

    find_by(name: context).children.each do |group|
      group.children.each do |category|
        category.name = group.name + ' - ' + category.name
        categories << category
      end

      categories << group if group.leaf?
    end

    categories.sort_by(&:name)
  end

  def self.categories_with_parent_name(context)
    Shared::Category.find_by(name: context).self_and_descendants.each do |category|
      category.name = category.parent.name + ' - ' + category.name unless category.root?
    end
  end
end
end
