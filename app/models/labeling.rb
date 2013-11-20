class Labeling < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :answer
  belongs_to :label
end
