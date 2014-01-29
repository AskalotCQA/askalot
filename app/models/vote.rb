class Vote < ActiveRecord::Base
  belongs_to :voter, class_name: :User
  belongs_to :votable, polymorphic: true

  scope :by,   lambda { |user| where(voter: user) }
  scope :for,  lambda { |model| where(votable_type: model.to_s.classify) }
end
