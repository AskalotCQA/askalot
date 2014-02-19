class Answer < ActiveRecord::Base
  include Commentable
  include Evaluable
  include Votable
  include Watchable

  belongs_to :author, class_name: :User, counter_cache: true
  belongs_to :question, counter_cache: true

  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings

  validates :text, presence: true

  scope :by,  lambda { |user| where(author: user) }
  scope :for, lambda { |question| where(question: question) }

  scope :labeled_with, lambda { |label| joins(:labelings).merge(Labeling.with label) }

  def labeled_with(label)
    labelings.with label
  end

  def labeled_by?(user, label)
    labelings.by(user).with(label).any?
  end

  def toggle_labeling_by!(user, label)
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
end
