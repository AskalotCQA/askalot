class Answer < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :question

  has_many :labelings
  has_many :labels, through: :labelings

  has_many :watchings, as: :watchable

  has_many :votes, as: :votable

  validates :text, presence: true

  def labeled_by?(user, value)
    labels.exists? labeling_author: user, value: value
  end

  def label_by!(user, value)
    # TODO
  end

  def helpful?
    labels.exists? value: :helpful
  end
end

