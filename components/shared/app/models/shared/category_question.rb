module Shared
  class CategoryQuestion < ActiveRecord::Base
    include Shared::Deletable

    belongs_to :category
    belongs_to :question

    belongs_to :shared_through_category, foreign_key: 'shared_through_category_id', class_name: Shared::Category

    scope :shared, -> { where('shared') }

    self.table_name = 'categories_questions'
  end
end
