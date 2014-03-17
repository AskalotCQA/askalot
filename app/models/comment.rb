class Comment < ActiveRecord::Base
  include Deletable
  include Editable
  include Touchable
  include Watchable

  belongs_to :author, class_name: :User, counter_cache: true
  belongs_to :commentable, polymorphic: true, counter_cache: true

  has_many :revisions, class_name: :CommentRevision, dependent: :destroy

  validates :text, presence: true

  scope :by,  lambda { |user| where(author: user) }
  scope :for, lambda { |model| where(commentable_type: model.to_s.classify) }

  def to_question
    commentable.to_question
  end
end
