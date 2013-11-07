class QuestionTagging < ActiveRecord::Base
  belongs_to :question
  belongs_to :tag, class_name: :QuestionTag
end
