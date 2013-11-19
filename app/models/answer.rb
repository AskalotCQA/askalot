class Answer < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :question

  acts_as_taggable_on :labels

  validates :text,  presence: true
end