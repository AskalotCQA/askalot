module Evaluable
  extend ActiveSupport::Concern

  included do
    has_many :evaluations, as: :evaluable

    scope :evaluated, lambda { joins(:evaluations).uniq }
  end
end
