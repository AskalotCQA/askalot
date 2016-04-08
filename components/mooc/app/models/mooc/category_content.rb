module Mooc
  class CategoryContent < ActiveRecord::Base
    belongs_to :category, class_name: :'Shared::Category'

    validates :content, presence: true
    validates :category_id, presence: true, uniqueness: true
  end
end
