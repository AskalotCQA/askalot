class Answer < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :question

  has_many :labelings
  has_many :labels, through: :labelings

  has_many :watchings, as: :watchable

  has_many :votes, as: :votable

  validates :text, presence: true

  def labeled_with(value)
    labelings.with value
  end

  def labeled_by?(user, value)
    labels.where(labelings: { author: user }, value: value).any?
  end

  def toggle_labeling_by!(user, value)
    return Labeling.create! author: user, answer: self, label: Label.where(value: :helpful).first_or_create! unless labeled_by?(user, value)

    Labeling.where(author: user, answer: self).first.destroy
  end

  def best?
    labels.exists? value: :best
  end

  def helpful?
    labels.exists? value: :helpful
  end
end

