class Category < ActiveRecord::Base
  include Watchable

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

  def category_list
    self.tags.map { |t| t.name }.join(", ")
  end

  def category_list=(new_value)
    tag_names = new_value.split(/,\s+/)
    self.tags = tag_names.map { |name| Tag.where('name = ?', name).first or Tag.create(:name => name) }
  end
end
