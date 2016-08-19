module Shared
class Tag < ActiveRecord::Base
  include Tags::Searchable
  include Watchable

  has_many :taggings, dependent: :restrict_with_exception
  has_many :questions, through: :taggings
  has_many :answers, through: :questions
  has_many :related_categories, -> { distinct }, through: :questions, source: :related_categories

  scope :recent,  lambda { where('tags.created_at >= ?', Time.now - 1.month ).unscope(:order).order('tags.created_at') }
  scope :popular, lambda { select('tags.id').group('tags.id, categories.id').unscope(:order).order('count(*) desc').limit(30) }
  scope :in_context, lambda { |context| includes(:related_categories).where(categories: { id: context }) }

  before_save :normalize

  self.table_name = 'tags'

  def self.current_academic_year_value
    year = (now = Time.now).month >= 9 ? now.year : (now.year - 1)

    "#{year}-#{(year + 1).to_s[-2..-1]}"
  end

  def value
    read_attribute(:name)
  end

  def normalize
    self.name = name.to_s.downcase.gsub(/[^[:alnum:]#\-\+\.]+/, '-').gsub(/\A-|-\z/, '')
  end

  def count(context = Shared::Context::Manager.current_context_id)
    questions.in_context(context).size
  end

  def related_contexts
    depth = Rails.module.mooc? ? 0 : 1;

    related_categories.where(depth: depth)
  end

  def available_in_current_context?
    self.related_contexts.where(id: Shared::Context::Manager.current_context_id).count > 0
  end
end
end
