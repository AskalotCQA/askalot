class Question < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :category

  has_many :answers

  acts_as_taggable

  validates :title, presence: true
  validates :text,  presence: true

  def labels
    [category] + tags.all
  end
end
