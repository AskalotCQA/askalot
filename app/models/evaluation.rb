class Evaluation < ActiveRecord::Base
  belongs_to :evaluator, class_name: :User
  belongs_to :evaluable, polymorphic: true
end
