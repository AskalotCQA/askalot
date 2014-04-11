class Tagging < ActiveRecord::Base
  include Deletable
  include Notifiable

  belongs_to :author, class_name: :User
  belongs_to :question
  belongs_to :tag

  scope :by,   lambda { |user| where author: user }
  scope :for,  lambda { |answer| where question: answer }
  scope :with, lambda { |tag| tag.is_a?(Tag) ? where(tag: tag) : joins(:tag).where(tags: { name: tag }) }
end
