module Shared::Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, class_name: 'Shared::Comment', as: :commentable, dependent: :destroy

    scope :commented, lambda { joins(:comments).uniq }
  end
end
