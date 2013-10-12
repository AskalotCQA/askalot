class Event < ActiveRecord::Base
  attr_accessible :data

  validates :data, presence: true
end
