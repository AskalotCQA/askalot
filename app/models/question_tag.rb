class QuestionTag < ActiveRecord::Base
  has_many :taggings, class_name: :QuestionTagging

  has_many :questions, through: :taggings

  validates :name, presence: true, uniqueness: true
end
