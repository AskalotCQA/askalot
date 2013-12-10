class View < ActiveRecord::Base
  belongs_to :viewer, class_name: :User
  belongs_to :question
end
