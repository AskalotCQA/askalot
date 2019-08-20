module Shared
class Category < ActiveRecord::Base
  acts_as_nested_set

  include Shared::Listable
  include Shared::Categories::Searchable
  include Shared::Watchable

  has_many :questions, dependent: :restrict_with_exception
  has_many :answers, through: :questions

  has_many :assignments, dependent: :destroy
  has_many :users, through: :assignments
  has_many :roles, through: :assignments
  has_many :category_questions, dependent: :destroy if Shared::CategoryQuestion.table_exists?
  has_many :related_questions, -> { distinct }, through: :category_questions, source: :question
  has_many :related_answers, -> { distinct }, through: :related_questions, source: :answers

  has_many :category_questions_shared_through_me, foreign_key: 'shared_through_category_id', class_name: Shared::CategoryQuestion

  has_many :context_users, foreign_key: 'context_id'
  has_many :users, through: :context_users, class_name: 'Shared::User', source: :user

  has_many :teacher_assistant_assignments, -> { where(role_id: Shared::Role::teacher_assistant.id) }, class_name: "Shared::Assignment"
  has_many :teacher_assistants, through: :teacher_assistant_assignments, class_name: 'Shared::User', source: :user

  validates :name, presence: true

  before_save  :remember_what_changed
  before_save  :check_uuid
  after_save   :update_categories
  after_save   :update_categories_questions
  after_save   :update_assignments

  scope :with_slido, -> { where.not(slido_username: nil) }
  scope :with_questions, lambda { joins(:related_questions).uniq }
  scope :askable, -> { where(askable: true) }
  scope :shared, -> { where(shared: true) }
  scope :in_contexts, lambda { |contexts| Category.all_in_contexts(contexts, self) }
  scope :not_unknown, -> { where.not(name: 'unknown') }
  scope :visible, -> { where(visible: true) }

  attr_accessor :copied
  attr_reader :what_changed

  self.table_name = 'categories'

  def count
    questions.reload.size
  end

  def effective_tags
    public_tags
  end

  def tags=(values)
    write_attribute(:tags, Shared::Tags::Extractor.extract(values))
  end

  def public_tags=(values)
    write_attribute(:public_tags, Shared::Tags::Extractor.extract(values))
  end

  def has_teachers?
    teachers.length > 0
  end

  def teachers
    roles = Shared::Role::teacher_roles.map(&:id)
    list  = association(:assignments).loaded? ? assignments.select { |item| roles.include? item.role_id } : assignments.where({ role_id: roles })

    list.map { |t| t.user }
  end

  def name_with_teacher_supported
    return "#{full_public_name}#{I18n.t('category.teacher_supported')}" if has_teachers?
    full_public_name
  end

  def leaves_with_metadata
    year_category = self

    while year_category.depth > 1
      year_category = year_category.parent
    end

    leaves = self.leaves.includes(:assignments, :parent).where(askable: true).visible.not_unknown.unscope(:order).order(:full_public_name)
    leaves = leaves.unscope(where: :askable) unless year_category.askable

    leaves.map {|category| [category, {data: {tags: category.effective_tags, icon: category.has_teachers? ? (ApplicationController.new.render_to_string partial: 'shared/categories/teacher_icon', locals: {category: category}, layout: false) : '', description: category.description.nil? ? category.parent.description : category.description }}]}
  end

  def self.all_in_contexts(contexts, relation = nil)
    relation   ||= Category::all
    conditions = []

    Category::where(id: contexts).each do |category|
      conditions.append "(lft >= #{category.lft} AND rgt <= #{category.rgt})"
    end

    conditions.empty? ? relation.where('1 = 2') : relation.where(conditions.join(' OR '))
  end

  def all_versions
    Shared::Category.where(uuid: self.uuid).where.not(id: self.id)
  end

  def related_contexts
    depth = Rails.module.mooc? ? 0 : 1

    self_and_ancestors.where(depth: depth)
  end

  def available_in_current_context?
    self.related_contexts.where(id: Shared::Context::Manager.current_context_id).count > 0
  end

  def can_have_subcategories?
    self.questions_count == 0
  end

  def custom?
    self.lti_id.blank?
  end

  def visible?
    Shared::CategoryDepth.visible_depths.include? self.depth
  end

  def parent_watchers
    self_and_ancestors.map(&:watchers).flatten
  end



  def remember_what_changed
    @what_changed = changed || []
  end

  def check_uuid
    return true unless self.uuid.blank?

    random_token = rand(36**5).to_s(36)
    self.uuid    = "#{self.name.to_s.parameterize}-#{random_token}"
  end

  def update_categories
    return true unless Shared::Category.column_names.include? 'full_public_name'

    self.self_and_descendants.each do |category|
      category.refresh_full_tree_name
      category.refresh_full_public_name
      category.refresh_public_tags

      if (category.changed & ['full_tree_name', 'full_public_name', 'public_tags']).any?
        category.save
      end
    end
  end

  def refresh_full_tree_name
    return true unless Shared::Category.column_names.include? 'full_tree_name'

    self.full_tree_name = self.self_and_ancestors.select { |category| category.name != 'root' }.map { |category| category.name }.join(' - ')
  end

  def refresh_full_public_name
    return true unless Shared::Category.column_names.include? 'full_public_name'

    depths = CategoryDepth.public_depths
    names  = self.ancestors.select { |category| depths.include? category.depth }.map { |category| category.name }
    names << self.name

    self.full_public_name = names.join(' - ')
  end

  def refresh_public_tags
    return true unless Shared::Category.column_names.include? 'public_tags'

    self.public_tags = self.self_and_ancestors.map { |category| category.tags }.flatten
  end

  def update_assignments
    if (@what_changed & ['parent_id']).any?
      self.ancestors.each do |ancestor|
        ancestor.assignments.each do |assignment|
          assignment.add_assignments_to_descendants
        end
      end
    end
  end

  def update_categories_questions
    if (@what_changed & ['parent_id', 'visible', 'uuid', 'shared']).any?
      self.related_questions.each do |question|
        question.category_questions.delete_all
        question.register_question
      end

      self.questions.each do |question|
        question.category_questions.delete_all
        question.register_question
      end

      if self.shared
        # register questions from shared categories to me
        self.all_versions.each do |category|
          category.questions.each do |question|
            question.register_question
          end
        end
      else
        self.category_questions_shared_through_me.destroy_all
      end
    end
  end




  # complete reload of categories_questions, used by migrations only
  def reload_categories_questions
    self.self_and_descendants.each do |category|
      category.category_questions.delete_all
    end

    self.self_and_descendants.each do |category|
      # register my questions
      category.questions.each do |question|
        question.register_question
      end

      # register questions from all my versions
      self.all_versions.each do |category|
        category.questions.each do |question|
          question.register_question
        end
      end
    end
  end

  def self.rebuild!
    super
    self.update_all("#{depth_column_name} = ((select count(*) from #{self.quoted_table_name} t where t.lft <= #{self.quoted_table_name}.lft and t.rgt >= #{self.quoted_table_name}.rgt) - 1)")
  end





  def copy(parent_cat, parent_id)
    category_copy = self.duplicate
    category_copy.parent_id = parent_id ? parent_id : parent_cat.id

    category_copy.save

    duplicate_watchings(category_copy)
    duplicate_assignments(category_copy)

    category_copy
  end

  protected

  def duplicate
    duplicated_attributes = attributes.slice('name', 'tags', 'uuid', 'public_tags', 'shared', 'askable', 'description')

    Shared::Category.new(duplicated_attributes)
  end

  def duplicate_watchings(category_copy)
    watchings = Shared::Watching.where(watchable_id: self.id, watchable_type: 'Shared::Category')

    return unless watchings

    watchings.each do |watching|
      watching.copy(category_copy.id, category_copy.related_contexts.first.id) if watching.watcher.role == :teacher || self.teachers.include?(watching.watcher) || self.full_tree_name.include?('Všeobecné')
    end
  end

  def duplicate_assignments(category_copy)
    assignments = self.assignments

    return unless assignments

    assignments.each { |assignment| assignment.copy(category_copy.id) }
  end
end
end
