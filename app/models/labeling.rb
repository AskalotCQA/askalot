class Labeling < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :label
  belongs_to :answer
end
