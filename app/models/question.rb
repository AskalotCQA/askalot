class Question < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :category

  has_many :taggings, class_name: :QuestionTagging

  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :text,  presence: true
end
