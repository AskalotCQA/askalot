class Evaluation < ActiveRecord::Base
  include Deletable

  belongs_to :evaluator, class_name: :User
  belongs_to :evaluable, polymorphic: true

  validates :value, presence: true, inclusion: { in: -2..2 }

  scope :by, lambda { |user| where(evaluator: user) }

  before_save :normalize

  def normalize
    self.text = nil if text.blank?
  end
end
