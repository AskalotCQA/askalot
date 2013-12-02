class Answer < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :question

  has_many :labelings
  has_many :labels, through: :labelings

  has_many :watchings, as: :watchable

  has_many :votes, as: :votable

  validates :text, presence: true

  def labeled_with(label)
    labelings.with label
  end

  def labeled_by?(user, label)
    labelings.by(user).with(label).any?
  end

  def toggle_labeling_by!(user, label)
    remove_label(user, label) if label == :best 

    label = Label.where(value: label).first_or_create! unless label.is_a? Label

    return Labeling.create! author: user, answer: self, label: label unless labeled_by?(user, label)

    Labeling.where(author: user, answer: self, label: label).first.destroy
  end

  def best?
    labels.exists? value: :best
  end

  def helpful?
    labels.exists? value: :helpful
  end

  def verified?
    labels.exists? value: :verified
  end

  def remove_label(user, label)
    label = Label.where(value: label).first_or_create! unless label.is_a? Label
    question.answers.each { |a| Labeling.where(author: user, answer: a, label: label).first.destroy if a.labeled_by?(user, label)  }
  end
end
