module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy

    scope :commented, lambda { joins(:comments).uniq }
  end
end
