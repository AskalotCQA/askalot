module Shared
  class Recommendation < ActiveRecord::Base
    include Deletable

    belongs_to :question
    belongs_to :user

    self.table_name = 'recommendations'

  end
end
