module Shared
class New < ActiveRecord::Base
  scope :active, -> { where(show: true) }

  self.table_name = 'news'
end
end
