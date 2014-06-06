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

  def tags=(values)
    write_attribute(:tags, Tags::Extractor.extract(values))
  end
end
