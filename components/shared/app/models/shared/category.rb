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

  validates :name, presence: true

  before_save  :update_changed
  after_create :reload_question_counters
  after_create :reload_answer_counters
  after_create :save_parent_tags
  after_update :check_changed_sharing
  after_save   :update_public_tags
  after_save   :refresh_names

  scope :with_slido, -> { where.not(slido_username: nil) }
  scope :with_questions, -> { where.not(direct_shared_questions_count: 0) }
  scope :askable, -> { where(askable: true) }

  attr_reader :what_changed

  self.table_name = 'categories'

  def update_changed
    @what_changed = changed || []
  end

  def refresh_names
    refresh_descs            = false
    name_changed             = @what_changed.include? 'name'
    parent_id_changed        = @what_changed.include? 'parent_id'
    full_tree_name_changed   = @what_changed.include? 'full_tree_name'
    full_public_name_changed = @what_changed.include? 'full_public_name'

    if !full_tree_name_changed && (name_changed || parent_id_changed)
      self.refresh_full_tree_name
      refresh_descs = true
    end

    if !full_public_name_changed && (name_changed || parent_id_changed)
      self.refresh_full_public_name
      refresh_descs = true
    end

    if refresh_descs
      self.save validate: false

      self.descendants.each do |category|
        category.refresh_full_tree_name
        category.refresh_full_public_name
        category.save validate: false
      end
    end

    true
  end

  def refresh_full_tree_name
    # TODO (ladislav.gallay) Remove the filtering of 'root' node
    self.full_tree_name = self.self_and_ancestors.select { |item| item.name != 'root' }.map { |item| item.name }.join(' - ')
  end

  def refresh_full_public_name
    depths = CategoryDepth.public_depths
    names  = self.ancestors.select { |item| depths.include? item.depth }.map { |item| item.name }
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
    public_tags
  end

  def tags=(values)
    tags_array = Shared::Tags::Extractor.extract(values)
    self.public_tags = (self.public_tags + tags_array).uniq
    new_tags = tags_array - tags
    deleted_tags = tags - tags_array

    add_tags_to_descendants new_tags if new_tags.size > 0
    delete_tags_from_descendants deleted_tags if deleted_tags.size > 0
    write_attribute(:tags, tags_array)
  end

  def public_tags=(values)
    write_attribute(:public_tags, Shared::Tags::Extractor.extract(values))
  end

  def add_tags_to_descendants tags
    self_and_descendants.each do |category|
      category.public_tags = (category.public_tags + tags).uniq

      category.save
    end
  end

  def delete_tags_from_descendants tags
    self_and_descendants.each do |category|
      category.public_tags -= tags

      category.save
    end
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
        groups << group.children.with_questions.each do |category|
          category.name = group.name + ' - ' + category.name
        end if group.children.with_questions.size > 0
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

  def self.all_related_questions_for_categories(relation, category_ids)
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

  def save_parent_tags
    self.public_tags += ancestors.map { |ancestor| ancestor.tags }.flatten

    self.save!
  end

  def update_public_tags
    if @what_changed.include? 'parent_id'
      self_and_descendants.each do |category|
        category.public_tags = category.self_and_ancestors.map { |ancestor| ancestor.tags }.flatten.uniq.sort

        category.save
      end
    end
  end
end
end
