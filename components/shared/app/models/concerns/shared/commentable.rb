module University::Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, class_name: 'University::Comment', as: :commentable, dependent: :destroy

    scope :commented, lambda { joins(:comments).uniq }
  end
end
