class Comment < ActiveRecord::Base
  include Deletable

  belongs_to :author, class_name: :User, counter_cache: true
  belongs_to :commentable, polymorphic: true, counter_cache: true

  has_many :revisions, class_name: :CommentRevision

  validates :text, presence: true

  scope :by,  lambda { |user| where(author: user) }
  scope :for, lambda { |model| where(commentable_type: model.to_s.classify) }
end
