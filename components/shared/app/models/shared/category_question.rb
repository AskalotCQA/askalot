module Shared
class CategoryQuestion < ActiveRecord::Base
  belongs_to :category
  belongs_to :question

  scope :shared, -> { where('shared') }

  self.table_name = 'categories_questions'
end
end
