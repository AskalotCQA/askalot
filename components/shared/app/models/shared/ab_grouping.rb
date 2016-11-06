module Shared
  class AbGrouping < ActiveRecord::Base
    belongs_to :user
    belongs_to :ab_group

    self.table_name = 'ab_groupings'
  end
end
