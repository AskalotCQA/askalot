class Category < ActiveRecord::Base
  has_many :questions

  has_many :watchings, as: :watchable

  validates :name, presence: true, uniqueness: true

  def count
    questions.size
  end
end
