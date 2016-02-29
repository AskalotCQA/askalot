module Shared
class CategoryQuestion < ActiveRecord::Base
  include Shared::Deletable

  belongs_to :category, :counter_cache => true, :dependent => :delete
  belongs_to :question, :dependent => :delete

  belongs_to :shared_through_category, foreign_key: 'shared_through_category_id', class: Shared::Category

  scope :shared, -> { where('shared') }

  self.table_name = 'categories_questions'
end
end
