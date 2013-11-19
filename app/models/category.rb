class Category < ActiveRecord::Base
  has_many :questions

  validates :name, presence: true, uniqueness: true

  def count
    questions.size
  end
end
