module Shared
  class Recommendation < ActiveRecord::Base
    belongs_to :question
    belongs_to :user

    self.table_name = 'recommendations'

  end
end
