class Role < ActiveRecord::Base
  has_many :assignments, dependent: :restrict_with_exception
  has_many :users, through: :assignments
  has_many :categories, through: :assignments

  validates :name, presence: true
end
