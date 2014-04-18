module Labelable
  extend ActiveSupport::Concern

  included do
    has_many :labelings, dependent: :destroy
    has_many :labels, through: :labelings

    scope :labeled,   lambda { joins(:labelings) }
    scope :unlabeled, lambda { includes(:labelings).where(labelings: { answer_id: nil }) }

    scope :labeled_with, lambda { |label| joins(:labelings).merge(Labeling.with label) }
  end

  def labeled_by?(user, label)
    labelings.by(user).with(label).any?
  end

  def toggle_labeling_by!(user, label)
    Labeling.with(label).deleted_or_new(author: user, answer: self).toggle_deleted_by! user
  end
end
