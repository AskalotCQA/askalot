class Answer
  class Profile < ActiveRecord::Base
    belongs_to :answer

    symbolize :property, in: [:quality]
    symbolize :source,   in: [:QE]
  end
end
