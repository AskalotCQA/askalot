class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  has_many :question_taggings

  has_many :tags, through: :question_taggings

  validates :title, presence: true
  validates :text,  presence: true
end
