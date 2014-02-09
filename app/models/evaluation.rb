class Evaluation < ActiveRecord::Base
  belongs_to :evaluator, class_name: :User
  belongs_to :evaluable, polymorphic: true

  scope :by, lambda { |user| where(evaluator: user) }
end
