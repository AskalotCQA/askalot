module Shared
class CategoryQuestion < ActiveRecord::Base
  belongs_to :categories
  belongs_to :questions
  self.table_name = 'categories_questions'
end
end
