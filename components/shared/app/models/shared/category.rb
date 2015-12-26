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

  after_create { self.reload_question_counters }
  after_create { self.reload_answer_counters }
  after_update { self.check_changed_sharing }

  scope :with_slido, -> { where.not(slido_username: nil) }
  scope :askable, -> { where(askable: true) }

  before_save :refresh_names
  after_save :refresh_descendants_names
  scope :direct_and_shared_question_count?, -> { where.not(direct_shared_questions_count: 0) }

  scope :direct_and_shared_question_count?, -> { where.not(direct_shared_questions_count: 0) }

  self.table_name = 'categories'

  def refresh_names
    return true unless Category.column_names.include? 'full_tree_name'

    if !self.full_tree_name_changed? && self.name_changed?
      self.refresh_full_tree_name
      @refresh_descs = true
    end

    if !self.full_public_name_changed? && self.name_changed?
      self.refresh_full_public_name
      @refresh_descs = true
    end

    true
  end

  def refresh_descendants_names
    return true unless Category.column_names.include? 'full_tree_name'

    self.descendants.each do |category|
      category.refresh_full_tree_name
      category.refresh_full_public_name
      category.save validate: false
    end if defined?(@refresh_descs) && @refresh_descs

    @refresh_descs = false

    true
  end

  def refresh_full_tree_name
    # TODO (ladislav.gallay) Remove the filtering of 'root' node
    self.full_tree_name = self.self_and_ancestors.select { |item| item.name != 'root' }.map { |item| item.name }.join(' - ')
  end

  def refresh_full_public_name
    depths = CategoryDepth.public_depths

    names = self.ancestors.select { |item| depths.include? item.depth }.map { |item| item.name }
    names << self.name

    self.full_public_name = names.join(' - ')
  end

  def all_related_questions(relation)
    if self.shared
      uuids = self.self_and_descendants.map { |item| item.uuid }.reject { |item| item.nil? || item.blank? || item.empty?}
      category_ids = Shared::Category.select('id').where("uuid IN (?) AND created_at <= ?", uuids, self.created_at)
    else
      category_ids = self.self_and_descendants.map { |item| item.id }
    end

    relation ||= Shared::Question.all
    relation.where('category_id IN (?)', category_ids)
  end

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
    list = association(:assignments).loaded? ? assignments.select { |item| item.role_id = 2 } : assignments.where({ role_id: 2 })
    list.map { |t| t.user }
  end

  def has_teachers?
    teachers.length > 0
  end

  def name_with_teacher_supported
    return full_public_name + I18n.t('category.teacher_supported') if has_teachers?
    full_public_name
  end

  def self.groups_in_context(context)
    groups = []
    empty = []

    find_by(name: context).children.sort_by(&:name).each do |group|
      if group.children.size == 0
        empty << group
      else
        if group.children.direct_and_shared_question_count?.size > 0
          groups << group.children.questions?.each do |category|
            category.name = group.name + ' - ' + category.name
          end
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

  def all_versions
    Shared::Category.where("uuid = ? AND created_at <= ?", self.uuid, self.created_at)
  end

  def check_changed_sharing
    return unless self.shared_changed?
    all_versions.each do |category|
        category.reload_question_counters
        category.reload_answer_counters
    end
  end

  def all_directly_related_questions(relation = nil)
    category_ids = self.shared ? self.all_versions.select('id') : self.id

    relation ||= Shared::Question.all

    relation.where('category_id IN (?)', category_ids)
  end

  def reload_question_counters
    self.direct_questions_count = self.questions.count

    self.direct_shared_questions_count = all_directly_related_questions.count

    self.save!
  end

  def reload_answer_counters
    self.direct_answers_count = self.answers.size

    self.direct_shared_answers_count = Shared::Answer.where('question_id IN (?)', all_directly_related_questions.select('id')).count

    self.save!
  end
end
end
