class Category < ActiveRecord::Base
  include Watchable

  has_many :questions, dependent: :restrict_with_exception
  has_many :answers, through: :questions

  validates :name, presence: true, uniqueness: true

  scope :with_slido, -> { where.not(slido_username: nil) }

  def count
    questions.reload.size
  end
end
