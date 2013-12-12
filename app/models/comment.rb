class Comment < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :commentable, polymorphic: true

  validates :text, presence: true

  scope :by,  lambda { |user| where(author: user) }
  scope :for, lambda { |model| where(commentable_type: model.to_s.classify) }
end
