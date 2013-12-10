class Category < ActiveRecord::Base
  include Watchable

  has_many :questions

  validates :name, presence: true, uniqueness: true

  def count
    questions.size
  end
end
