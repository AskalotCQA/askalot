class Tag < ActiveRecord::Base
  has_many :question_taggings

  has_many :questions, through: :question_taggings

  validates :name, presence: true, uniqueness: true
end