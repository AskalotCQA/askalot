class Favorite < ActiveRecord::Base
  include Deletable

  belongs_to :favorer, class_name: :User, counter_cache: true
  belongs_to :question, counter_cache: true

  scope :by, lambda { |user| where(favorer: user) }
end
