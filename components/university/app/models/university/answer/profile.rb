module University
class Answer
  class Profile < ActiveRecord::Base
    belongs_to :answer

    symbolize :property, in: [:quality, :reputation]
    symbolize :source,   in: [:QE, :reputation]

    scope :for, lambda { |property| where(property: property) }

    self.table_name = 'answer_profiles'
  end
end
end
