class Event < ActiveRecord::Base
  validates :data, presence: true
end
