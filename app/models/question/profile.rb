class Question
  class Profile < ActiveRecord::Base
    belongs_to :question

    symbolize :property
    symbolize :source
  end
end
