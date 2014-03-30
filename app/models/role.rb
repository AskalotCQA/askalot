class Role < ActiveRecord::Base
  has_many :role_assignments, dependent: :restrict_with_exception

  has_many :users,      through: :role_assignments
  has_many :categories, through: :role_assignments

  validates :name, presence: true
end