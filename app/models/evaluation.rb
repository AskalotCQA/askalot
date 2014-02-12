class Evaluation < ActiveRecord::Base
  belongs_to :evaluator, class_name: :User
  belongs_to :evaluable, polymorphic: true

  validates :value, presence: true, inclusion: { in: -2..2 }

  scope :by, lambda { |user| where(evaluator: user) }
end
