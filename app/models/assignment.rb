class Assignment < ActiveRecord::Base
  belongs_to :role
  belongs_to :user
  belongs_to :category
end
