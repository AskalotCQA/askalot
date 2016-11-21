module Shared
class Comment < ActiveRecord::Base
  include Authorable
  include Attachmentable
  include Deletable
  include Editable
  include Notifiable
  include Touchable

  belongs_to :commentable, -> { unscope where: :deleted }, polymorphic: true, counter_cache: true

  has_many :revisions, class_name: :'Comment::Revision', dependent: :destroy

  validates :text, presence: true

  scope :by,  lambda { |user| where(author: user) }
  scope :for, lambda { |model| where(commentable_type: model.to_s.classify) }

  self.table_name = 'comments'

  def to_question
    self.commentable.to_question
  end
end
end
