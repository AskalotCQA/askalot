module Evaluable
    extend ActiveSupport::Concern

    included do
      has_many :evaluations, as: :evaluable

    end
  end
