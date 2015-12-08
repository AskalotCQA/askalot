module Shared
  class CategoryDepth < ActiveRecord::Base
    self.table_name = 'category_depths'

    def self.public_depths
      @@public_depths ||= CategoryDepth.all.where(is_in_public_name: true).map { |item| item.depth }
    end
  end
end
