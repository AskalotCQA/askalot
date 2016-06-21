module Shared
  class News < ActiveRecord::Base
    scope :active, lambda { where(show: true) }

    default_scope -> { order(created_at: :desc) }

    self.table_name = 'news'
  end
end
