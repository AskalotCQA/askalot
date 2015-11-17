module University
class Question
  class Profile < ActiveRecord::Base
    belongs_to :question

    symbolize :property
    symbolize :source

    scope :as,  lambda { |source| where(source: source) }
    scope :for, lambda { |property| where(property: property) }

    self.table_name = 'question_profiles'
  end
end
end
