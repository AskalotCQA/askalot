module Shared
class CategoryQuestion < ActiveRecord::Base
  include Shared::Deletable

  belongs_to :category, :counter_cache => true, :dependent => :delete
  belongs_to :question, :dependent => :delete

  scope :shared, -> { where('shared') }

  self.table_name = 'categories_questions'
end
end
