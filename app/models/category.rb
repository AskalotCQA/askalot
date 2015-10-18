class Category < ActiveRecord::Base
  include Watchable

  include Categories::Searchable

  has_many :questions, dependent: :restrict_with_exception
  has_many :answers, through: :questions

  has_many :assignments, dependent: :destroy
  has_many :users, through: :assignments
  has_many :roles, through: :assignments

  validates :name, presence: true, uniqueness: true

  scope :with_slido, -> { where.not(slido_username: nil) }

  def count
    questions.reload.size
  end

  def effective_tags
    tags << Tag.current_academic_year_value
  end

  def tags=(values)
    write_attribute(:tags, Tags::Extractor.extract(values))
  end

  def teachers
    assignments.where({ category_id: id, role_id: 2 }).map { |t| t.user }
  end

  def has_teachers?
    teachers.length > 0
  end
end
