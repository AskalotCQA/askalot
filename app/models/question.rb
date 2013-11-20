class Question < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :category

  has_many :answers

  has_many :favorites

  has_many :watchings, as: :watchable

  acts_as_taggable

  validates :title, presence: true, length: { minimum: 2, maximum: 250 }
  validates :text,  presence: true, length: { minimum: 2 }

  def labels
    [category] + tag_counts_on(:tags)
  end
end
