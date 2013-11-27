class Answer < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :question

  has_many :labelings
  has_many :labels, through: :labelings

  has_many :watchings, as: :watchable

  has_many :votes, as: :votable

  validates :text, presence: true

  def labeled_by?(user, value)
    labelings.where(author: user).joins(:label).where(author: user).first
  end

  def toggle_labeling_by!(user, value)
    return Labeling.create! author: user, answer: self, label: Label.first_or_create!(value: value) unless labeled_by?(user, value)

    Labeling.where(author: user, answer: self).first.destroy
  end

  def helpful?
    labels.exists? value: :helpful
  end
end

