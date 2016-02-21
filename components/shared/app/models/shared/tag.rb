module Shared
class Tag < ActiveRecord::Base
  include Tags::Searchable
  include Watchable

  has_many :taggings, dependent: :restrict_with_exception
  has_many :questions, through: :taggings
  has_many :answers, through: :questions

  scope :recent,  lambda { where('tags.created_at >= ?', Time.now - 1.month ).unscope(:order).order('tags.created_at') }
  scope :popular, lambda { select('tags.*, count(*) as c').joins(:taggings).group('tags.id').unscope(:order).order('c desc').limit(30) }

  before_save :normalize

  self.table_name = 'tags'

  def self.current_academic_year_value
    year = (now = Time.now).month >= 9 ? now.year : (now.year - 1)

    "#{year}-#{(year + 1).to_s[-2..-1]}"
  end

  def self.tags_in_context(context = Shared::ApplicationHelper.current_context)
    category_ids = Shared::Category.find_by(name: context).descendants.leaves.pluck(:id)
    question_ids = Shared::Question.where(category_id: category_ids).pluck(:id)

    Shared::Tag.joins(:taggings).where(taggings: { question_id: question_ids }).uniq
  end

  def value
    read_attribute(:name)
  end

  def normalize
    self.name = name.to_s.downcase.gsub(/[^[:alnum:]#\-\+\.]+/, '-').gsub(/\A-|-\z/, '')
  end

  def count
    questions.size
  end
end
end
