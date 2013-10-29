class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  validates :title, presence: true
  validates :text,  presence: true
end
